//
//  EditExpenditureViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/5/2.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import IGLDropDownMenu

class EditExpenditureViewController: UIViewController {
    
    @IBOutlet weak var moneyTextfield: UITextField!
    
    var typeDropDownMenu = IGLDropDownMenu()
    var typeDetailDropDownMenu = IGLDropDownMenu()
    var typeArray: NSArray = ["食", "衣", "住", "行", "育", "樂"]
    var typeDetailDic: [String : NSArray] = ["食" : ["早餐", "午餐", "下午茶", "晚餐", "零食", "其他"],
                                             "衣" : ["服飾", "鞋子", "其他"],
                                             "住" : ["房租", "水費", "電費", "其他"],
                                             "行" : ["交通費", "其他"],
                                             "育" : ["教育", "其他"],
                                             "樂" : ["旅遊", "看電影", "其他"]]
    var type: String?
    var typeDetail: String?
    var isSelectType = false
    var index: IndexPath?
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let inputMoney = Int64(moneyTextfield.text!),
            let typeText = type,
            let typeDetailText = typeDetail{
            
            let expenditureVC = segue.destination as? ExpenditureViewController
            if let indexPath = index{
                expenditureVC?.currentDateExpenditureArray[indexPath.row].money = inputMoney
                expenditureVC?.currentDateExpenditureArray[indexPath.row].type = typeText
                expenditureVC?.currentDateExpenditureArray[indexPath.row].typeDetail = typeDetailText
                expenditureVC?.expenditureTableView.reloadData()
                expenditureVC?.animateTableView()
            }
            expenditureVC?.allExpenditureArray[count].money = inputMoney
            expenditureVC?.allExpenditureArray[count].type = typeText
            expenditureVC?.allExpenditureArray[count].typeDetail = typeDetailText
            expenditureVC?.saveExpenditures()
            
            //  改掉total的金額
            if let currentDateExpenditureArray = expenditureVC?.currentDateExpenditureArray{
                var todayMoney: Int64 = 0
                for expenditure in currentDateExpenditureArray{
                    todayMoney += expenditure.money
                }
                if let todayMoney = expenditureVC?.formatter.string(from: NSNumber(value: todayMoney)){
                    expenditureVC?.totalExpenditureLabel.text = "\(todayMoney)"
                }
            }
        }
    }
    //  隨便按一個地方，彈出鍵盤就會收回
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension EditExpenditureViewController: IGLDropDownMenuDelegate{
    
    func setupEditType(){
        let typeDropDownItems: NSMutableArray = NSMutableArray()
        for i in 0...(typeArray.count-1) {
            let typeItem = IGLDropDownItem()
            typeItem.iconImage = UIImage(named: "\(typeArray[i])")
            typeItem.text = "\(typeArray[i])"
            typeItem.showBackgroundShadow = true
            typeDropDownItems.add(typeItem)
        }
        if let typeText = type{
            typeDropDownMenu.menuIconImage = UIImage(named: "\(typeText)")
            typeDropDownMenu.menuText = "\(typeText)"
        }
        typeDropDownMenu.dropDownItems = typeDropDownItems as [AnyObject]
        typeDropDownMenu.paddingLeft = 15
        typeDropDownMenu.frame = CGRect(x: 15, y: 180, width: 180, height: 45)
        typeDropDownMenu.delegate = self
        typeDropDownMenu.type = .stack
        typeDropDownMenu.gutterY = 5
        typeDropDownMenu.itemAnimationDelay = 0.1
        typeDropDownMenu.rotate = .random
        typeDropDownMenu.shouldFlipWhenToggleView = true
        typeDropDownMenu.reloadView()
        self.view.addSubview(self.typeDropDownMenu)
    }
    
    func setupEditTypeDetail(){
        let typeDetailDropDownItems:NSMutableArray = NSMutableArray()
        if let typeDetailText = typeDetail{
            typeDetailDropDownMenu.menuText = "\(typeDetailText)"
            if let typeText = type{
                if let typeDetailArray: NSArray = typeDetailDic[typeText]{
                    for i in 0...(typeDetailArray.count-1) {
                        let typeDetailItem = IGLDropDownItem()
                        typeDetailItem.text = "\(typeDetailArray[i])"
                        typeDetailItem.showBackgroundShadow = true
                        typeDetailDropDownItems.add(typeDetailItem)
                    }
                }
                
            }
        }
        typeDetailDropDownMenu.dropDownItems = typeDetailDropDownItems as [AnyObject]
        typeDetailDropDownMenu.paddingLeft = 15
        typeDetailDropDownMenu.frame = CGRect(x: 220, y: 180, width: 180, height: 45)
        typeDetailDropDownMenu.delegate = self
        typeDetailDropDownMenu.type = .stack
        typeDetailDropDownMenu.gutterY = 5
        typeDetailDropDownMenu.itemAnimationDelay = 0.1
        typeDetailDropDownMenu.rotate = .random
        typeDetailDropDownMenu.shouldFlipWhenToggleView = true
        typeDetailDropDownMenu.reloadView()
        self.view.addSubview(self.typeDetailDropDownMenu)
    }
    
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        
        if dropDownMenu == typeDropDownMenu{
            let typeItem: IGLDropDownItem = typeDropDownMenu.dropDownItems[index] as! IGLDropDownItem
            if let typeText = typeItem.text{
                type = typeText
                isSelectType = true
                if isSelectType {
                    setupEditTypeDetail()
                    typeDetailDropDownMenu.menuText = "Choose TypeDetail"
                    typeDetailDropDownMenu.reloadView()
                    isSelectType = false
                }
            }
        }
        else if dropDownMenu == typeDetailDropDownMenu{
            let typeDetailItem: IGLDropDownItem = typeDetailDropDownMenu.dropDownItems[index] as! IGLDropDownItem
            if let typeDetailText = typeDetailItem.text{
                typeDetail = typeDetailText
            }
        }
        
    }
    
}

