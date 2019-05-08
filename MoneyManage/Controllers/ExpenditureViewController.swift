//
//  FirstViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/4/4.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import CoreData
import ViewAnimator

class ExpenditureViewController: UIViewController{
    
    @IBOutlet weak var expenditureTableView: UITableView!
    @IBOutlet weak var totalExpenditureLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var allExpenditureArray = [Expenditure]()
    var currentDateExpenditureArray = [Expenditure]()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var currentSelectDate = Date()
    var currentSelectDateText: String?
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadExpenditure()
        getDate()
        initTodayMoney()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func getDate(){
        //  顯示 datePicker 方式和大小
        datePicker.locale = Locale.current
        dateFormatter.locale = datePicker.locale
        dateFormatter.dateStyle = .medium
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        currentSelectDateText = dateFormatter.string(from: datePicker.date)
        navigationItem.title = currentSelectDateText
    }
    
    //  取今天所有的支出總和
    func initTodayMoney(){
        currentDateExpenditureArray = [Expenditure]()
        totalExpenditureLabel.text = ""
        var todayMoney: Int64 = 0
        for expenditure in allExpenditureArray{
            if expenditure.date == currentSelectDateText{
                todayMoney += expenditure.money
                currentDateExpenditureArray.append(expenditure)
            }
        }
        formatter.numberStyle = .currency
        if let todayMoney = formatter.string(from: NSNumber(value: todayMoney)){
            totalExpenditureLabel.text = "\(todayMoney)"
        }
    }
    
    //  tableview顯示特效
    func animateTableView(){
        let animations = [AnimationType.from(direction: .left, offset: 10.0)]
        UIView.animate(views: expenditureTableView.visibleCells, animations: animations, reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0, animationInterval: 0.05, duration: ViewAnimatorConfig.duration, completion: nil)
    }
    //  左上角按鈕選擇日期
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        //  建立警告控制器顯示 datePicker
        let dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        dateAlert.view.addSubview(datePicker)
        //  警告控制器裡的確定按鈕
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            self.currentDateExpenditureArray = [Expenditure]()
            // 按下確定，讓標題改成選取到的日期
            if var currentSelectDateText = self.currentSelectDateText{
                currentSelectDateText = self.dateFormatter.string(from: self.datePicker.date)
                self.navigationItem.title = currentSelectDateText
                self.currentSelectDate = self.datePicker.date
                
                //  取選取日期的支出資料
                var todayMoney:Int64 = 0
                for expenditure in self.allExpenditureArray{
                    if expenditure.date == currentSelectDateText{
                        self.currentDateExpenditureArray.append(expenditure)
                        todayMoney += expenditure.money
                    }
                }
                if let todayMoney = self.formatter.string(from: NSNumber(value: todayMoney)){
                    self.totalExpenditureLabel.text = "\(todayMoney)"
                }
                self.expenditureTableView.reloadData()
                self.animateTableView()
            }
        }
        dateAlert.addAction(okAction)
        //  警告控制器裡的取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        
        self.present(dateAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addExpenditureSegue"{
            let addExpenditureVC = segue.destination as? AddExpenditureViewController
            if var currentSelectDateText = currentSelectDateText{
                currentSelectDateText = dateFormatter.string(from: currentSelectDate)
                addExpenditureVC?.dateText = currentSelectDateText
                addExpenditureVC?.setupTypeInit()
            }
        }
        else if segue.identifier == "editExpenditureSegue"{
            if let indexPath = expenditureTableView.indexPathForSelectedRow{
                let editExpenditureVC = segue.destination as? EditExpenditureViewController
                editExpenditureVC?.type = currentDateExpenditureArray[indexPath.row].type
                editExpenditureVC?.typeDetail = currentDateExpenditureArray[indexPath.row].typeDetail
                editExpenditureVC?.index = indexPath
                
                var count = 0
                for expenditure in allExpenditureArray{
                    if expenditure.money == currentDateExpenditureArray[indexPath.row].money &&
                        expenditure.type == currentDateExpenditureArray[indexPath.row].type &&
                        expenditure.typeDetail == currentDateExpenditureArray[indexPath.row].typeDetail &&
                        expenditure.date == currentDateExpenditureArray[indexPath.row].date {
                        break
                    }
                    count += 1
                }
                editExpenditureVC?.count = count
                
                editExpenditureVC?.setupEditType()
                editExpenditureVC?.typeDropDownMenu.menuText = currentDateExpenditureArray[indexPath.row].type
                editExpenditureVC?.setupEditTypeDetail()
                editExpenditureVC?.typeDetailDropDownMenu.menuText = currentDateExpenditureArray[indexPath.row].typeDetail
                
                editExpenditureVC?.moneyTextfield.text = String(currentDateExpenditureArray[indexPath.row].money)
            }
        }
    }
    
    func saveExpenditures(){
        do{
            if context.hasChanges{
                try context.save()
            }
        }
        catch{
            print("Error saving context \(error)")
        }
    }
    func loadExpenditure(){
        let request: NSFetchRequest<Expenditure> = Expenditure.fetchRequest()
        do{
            allExpenditureArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
    }

    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }

}

//  tableView
extension ExpenditureViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - Tableview Datasource Methods
    //  tableView 的列數等於 moneyArray
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDateExpenditureArray.count
    }
    //  重複使用列數
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expenditureTableView.dequeueReusableCell(withIdentifier: "expenditureCell", for: indexPath)
        let expenditure = currentDateExpenditureArray[indexPath.row]
        if let type = expenditure.type,
            let typeDetail = expenditure.typeDetail{
            cell.imageView?.image = UIImage(named: "\(type)")
            cell.textLabel?.text = "\t類型：\(type)"
            if let expenditureMoney = formatter.string(from: NSNumber(value: expenditure.money)){
                cell.detailTextLabel?.text = "\(typeDetail) " + expenditureMoney
            }
        }
        return cell
    }
    //MARK: - Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expenditureTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //  在 tableView 上往左滑可以刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            for expenditure in allExpenditureArray{
                if currentDateExpenditureArray[indexPath.row] == expenditure{
                    context.delete(expenditure)
                    saveExpenditures()
                }
            }
            currentDateExpenditureArray.remove(at: indexPath.row)
            expenditureTableView.deleteRows(at: [indexPath], with: .fade)
            var todayMoney: Int64 = 0
            for expenditure in currentDateExpenditureArray{
                todayMoney += expenditure.money
            }
            if let todayMoney = formatter.string(from: NSNumber(value: todayMoney)){
                totalExpenditureLabel.text = "\(todayMoney)"
            }
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
