//
//  AddIncomeViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/4/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import IGLDropDownMenu

class AddIncomeViewController: UIViewController {

    @IBOutlet weak var moneyTextfield: UITextField!
    
    var typeDropDownMenu = IGLDropDownMenu()
    var typeArray: NSArray = ["薪水", "獎金", "補助", "投資", "其他"]
    var type: String?
    var dateText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let incomeVC = segue.destination as? IncomeViewController
        
        if let money = Int64(moneyTextfield.text!),
            let type = type,
            let dateText = dateText{
            //  建立新支出
            if let context = incomeVC?.context{
                let newIncome = Income(context: context)
                newIncome.money = money
                newIncome.type = type
                newIncome.date = dateText
                //  把新支出加入陣列中
                incomeVC?.allIncomeArray.append(newIncome)
                incomeVC?.saveIncome()
                incomeVC?.currentDateIncomeArray.append(newIncome)
                
                if let allIncomeArray = incomeVC?.allIncomeArray{
                    var todayMoney: Int64 = 0
                    for income in allIncomeArray{
                        if income.date == dateText{
                            todayMoney += income.money
                        }
                    }
                    if let todayMoney = incomeVC?.formatter.string(from: NSNumber(value: todayMoney)){
                        incomeVC?.totalIcomeLabel.text = "\(todayMoney)"
                    }
                }
                
            }
            incomeVC?.incomeTableView.reloadData()
            incomeVC?.animateTableView()
        }
        else{
            let noMoneyAlert = UIAlertController(title: "請輸入金額", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            noMoneyAlert.addAction(okAction)
            self.present(noMoneyAlert, animated: true, completion: nil)
        }
    }
    //隨便按一個地方，彈出鍵盤就會收回
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension AddIncomeViewController: IGLDropDownMenuDelegate{
    
    func setupAddType(){
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
        typeDropDownMenu.menuText = "Choose Type"
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
