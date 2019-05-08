//
//  EditIncomeViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/5/2.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import IGLDropDownMenu

class EditIncomeViewController: UIViewController {
    
    @IBOutlet weak var moneyTextfield: UITextField!
    
    var editIncomeArray = [Income]()
    var typeDropDownMenu = IGLDropDownMenu()
    var typeArray: NSArray = ["薪水", "獎金", "補助", "投資", "其他"]
    var type: String?
    var index: IndexPath?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let inputMoney = Int64(moneyTextfield.text!),
            let typeText = type{
            
            let incomeVC = segue.destination as? IncomeViewController
            if let indexPath = index{
                incomeVC?.currentDateIncomeArray[indexPath.row].money = inputMoney
                incomeVC?.currentDateIncomeArray[indexPath.row].type = typeText
                incomeVC?.incomeTableView.reloadData()
                incomeVC?.animateTableView()
            }
            incomeVC?.allIncomeArray[count].money = inputMoney
            incomeVC?.allIncomeArray[count].type = typeText
            incomeVC?.saveIncome()
            //  改掉total的金額
            if let currentDateIncomeArray = incomeVC?.currentDateIncomeArray{
                var todayMoney: Int64 = 0
                for income in currentDateIncomeArray{
                    todayMoney += income.money
                }
                if let todayMoney = incomeVC?.formatter.string(from: NSNumber(value: todayMoney)){
                    incomeVC?.totalIcomeLabel.text = "\(todayMoney)"
                }
            }
        }
    }
    //  隨便按一個地方，彈出鍵盤就會收回
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension EditIncomeViewController: IGLDropDownMenuDelegate{
    
    func setupEditType(){
        let typeDropDownItems: NSMutableArray = NSMutableArray()
        for i in 0...(typeArray.count-1) {
            let typeItem = IGLDropDownItem()
            //            typeItem.iconImage = UIImage(named: "\(typeArray[i])")
            typeItem.text = "\(typeArray[i])"
            typeItem.showBackgroundShadow = true
            typeDropDownItems.add(typeItem)
        }
        if let typeText = type{
            //            typeDropDownMenu.menuIconImage = UIImage(named: "\(typeText)")
            typeDropDownMenu.menuText = "\(typeText)"
        }
        typeDropDownMenu.dropDownItems = typeDropDownItems as [AnyObject]
        typeDropDownMenu.paddingLeft = 15
        typeDropDownMenu.frame = CGRect(x: 120, y: 180, width: 180, height: 45)
        typeDropDownMenu.delegate = self
        typeDropDownMenu.type = .stack
        typeDropDownMenu.gutterY = 5
        typeDropDownMenu.itemAnimationDelay = 0.1
        typeDropDownMenu.rotate = .random
        typeDropDownMenu.shouldFlipWhenToggleView = true
        typeDropDownMenu.reloadView()
        self.view.addSubview(self.typeDropDownMenu)
    }
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        
        if dropDownMenu == typeDropDownMenu{
            let typeItem: IGLDropDownItem = typeDropDownMenu.dropDownItems[index] as! IGLDropDownItem
            if let typeText = typeItem.text{
                type = typeText
            }
        }
        
    }
}
