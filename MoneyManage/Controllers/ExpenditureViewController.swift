//
//  FirstViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/4/4.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import CoreData

class ExpenditureViewController: UIViewController{
    
    @IBOutlet weak var ExpenditureTableView: UITableView!
    
    //  儲存輸入支出的錢
    var expenditureArray = [Expenditure]()
    var typeArray = ["食", "衣", "住", "行", "育", "樂"]
    var typeDetailDic = ["食" : ["早餐", "午餐", "下午茶", "晚餐", "零食", "其他"],
                         "衣" : ["服飾", "鞋子", "其他"],
                         "住" : ["房租", "水費", "電費", "其他"],
                         "行" : ["交通費", "其他"],
                         "育" : ["教育", "其他"],
                         "樂" : ["旅遊", "看電影", "其他"]]
    var selectType = ""
    var selectTypeDetail = ""
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentSelectDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDate()
        loadExpenditure()
        
        selectType = typeArray[0]
        if let chooseType = typeDetailDic[selectType]{
            selectTypeDetail = chooseType[0]
        }
    }
    
    func getDate(){
        //  顯示 datePicker 方式和大小
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale(identifier: "zh_CN")
        datePicker.locale = Locale(identifier: "zh_CN")
//        dateFormatter.locale = Locale.current
//        datePicker.locale = Locale.current
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        navigationItem.title = dateFormatter.string(from: datePicker.date)
    }
    
    //  左上角按鈕選擇日期
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        //  建立警告控制器顯示 datePicker
        let dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        dateAlert.view.addSubview(datePicker)
        //  警告控制器裡的確定按鈕
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            // 按下確定，讓標題改成選取到的日期
            self.navigationItem.title = self.dateFormatter.string(from: self.datePicker.date)
            self.currentSelectDate = self.datePicker.date
        }
        dateAlert.addAction(okAction)
        //  警告控制器裡的取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)

        self.present(dateAlert, animated: true, completion: nil)
    }
    
    @IBAction func addExpenditureButton(_ sender: UIBarButtonItem) {

        //  建立類型的 pickerView
        let typePicker = UIPickerView()
        typePicker.dataSource = self
        typePicker.delegate = self
        typePicker.frame = CGRect(x: 0, y: 35, width: 250, height: 155)
        //  建立警告控制器並加入 pickerView

        let addAlert = UIAlertController(title: "新增支出\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        addAlert.view.addSubview(typePicker)

        //  在警告控制器裡面加入 textfield
        var addMoneyTextField = UITextField()
        addAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Money"
            alertTextField.keyboardType = .numberPad
            addMoneyTextField = alertTextField
        }

        //  警告控制器裡的確定按鈕
        let okAction = UIAlertAction(title: "增加", style: .default) { (alert: UIAlertAction) in
            if let money = Int(addMoneyTextField.text!){
                let newExpenditure = Expenditure(context: self.context)
                newExpenditure.money = String(money)
                newExpenditure.type = self.selectType
                newExpenditure.date = self.currentSelectDate
                newExpenditure.typeDetail = self.selectTypeDetail
                self.expenditureArray.append(newExpenditure)
                self.saveExpenditures()
                self.ExpenditureTableView.reloadData()
            }
            else{
                let alert = UIAlertController(title: "新增錯誤", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let ok = UIAlertAction(title: "確定", style: .default, handler: nil)
                alert.addAction(ok)
            }
        }
        addAlert.addAction(okAction)
        //  警告控制器裡的取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        addAlert.addAction(cancelAction)

        self.present(addAlert, animated: true, completion: nil)
    }

    func saveExpenditures(){
        do{
            try context.save()
        }
        catch{
            print("Error saving context \(error)")
        }
    }
    func loadExpenditure(){
        let request: NSFetchRequest<Expenditure> = Expenditure.fetchRequest()
        do{
            expenditureArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
    }
    
}

//  tableView
extension ExpenditureViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - Tableview Datasource Methods
    //  tableView 的列數等於 moneyArray
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenditureArray.count
    }
    //  重複使用列數
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ExpenditureTableView.dequeueReusableCell(withIdentifier: "expenditureCell", for: indexPath)
        let expenditure = expenditureArray[indexPath.row]
        if let type = expenditure.type,
            let money = expenditure.money,
            let typeDetail = expenditure.typeDetail{
            cell.textLabel?.text = "\(type)\t\(typeDetail)"
            cell.detailTextLabel?.text = "$ \(money)"
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ExpenditureTableView.deselectRow(at: indexPath, animated: true)
    }

    //  在 tableView 上往左滑可以刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            context.delete(expenditureArray[indexPath.row])
            expenditureArray.remove(at: indexPath.row)
            saveExpenditures()
            ExpenditureTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

//  pickerView
extension ExpenditureViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return typeArray.count
        }
        if let typeDetailCount = typeDetailDic[selectType]?.count{
            return typeDetailCount
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return typeArray[row]
        }
        if let typeDetailSelect = typeDetailDic[selectType]{
           return  typeDetailSelect[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            selectType = typeArray[row]
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        else{
            if let detail = typeDetailDic[selectType]{
                selectTypeDetail = detail[row]
            }
        }
    }
    
}
