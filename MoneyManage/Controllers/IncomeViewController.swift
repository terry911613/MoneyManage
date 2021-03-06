//
//  SecondViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/4/4.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import CoreData
import ViewAnimator

class IncomeViewController: UIViewController {

    @IBOutlet weak var incomeTableView: UITableView!
    @IBOutlet weak var totalIcomeLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var allIncomeArray = [Income]()
    var currentDateIncomeArray = [Income]()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var currentSelectDate = Date()
    var currentSelectDateText: String?
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIncome()
        getDate()
        initTodayMoney() 
    }
    func getDate(){
        //  顯示 datePicker 方式和大小
        dateFormatter.dateStyle = .medium
        datePicker.locale = Locale.current
        dateFormatter.locale = datePicker.locale
        dateFormatter.dateStyle = .medium
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        currentSelectDateText = dateFormatter.string(from: datePicker.date)
        navigationItem.title = dateFormatter.string(from: datePicker.date)
    }
    //  取今天所有的支出總和
    func initTodayMoney(){
        currentDateIncomeArray = [Income]()
        totalIcomeLabel.text = ""
        var todayMoney: Int64 = 0
        for income in allIncomeArray{
            if income.date == currentSelectDateText{
                todayMoney += income.money
                currentDateIncomeArray.append(income)
            }
        }
        formatter.numberStyle = .currency
        if let todayMoney = formatter.string(from: NSNumber(value: todayMoney)){
            totalIcomeLabel.text = "\(todayMoney)"
        }
    }
    //  tableview顯示特效
    func animateTableView(){
        let animations = [AnimationType.from(direction: .left, offset: 10.0)]
        UIView.animate(views: incomeTableView.visibleCells, animations: animations, reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0, animationInterval: 0.05, duration: ViewAnimatorConfig.duration, completion: nil)
    }
    
    //  左上角按鈕選擇日期
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        //  建立警告控制器顯示 datePicker
        let dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        dateAlert.view.addSubview(datePicker)
        //  警告控制器裡的確定按鈕
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            self.currentDateIncomeArray = [Income]()
            // 按下確定，讓標題改成選取到的日期
            if var currentSelectDateText = self.currentSelectDateText{
                currentSelectDateText = self.dateFormatter.string(from: self.datePicker.date)
                self.navigationItem.title = currentSelectDateText
                self.currentSelectDate = self.datePicker.date
                
                var todayMoney:Int64 = 0
                for income in self.allIncomeArray{
                    if income.date == currentSelectDateText{
                        self.currentDateIncomeArray.append(income)
                        todayMoney += income.money
                    }
                }
                if let todayMoney = self.formatter.string(from: NSNumber(value: todayMoney)){
                    self.totalIcomeLabel.text = "\(todayMoney)"
                }
                self.incomeTableView.reloadData()
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
        
        if segue.identifier == "addIncomeSegue"{
            let addIncomeVC = segue.destination as? AddIncomeViewController
            if var currentSelectDateText = currentSelectDateText{
                currentSelectDateText = dateFormatter.string(from: currentSelectDate)
                addIncomeVC?.dateText = currentSelectDateText
                addIncomeVC?.setupAddType()
            }
        }
        else if segue.identifier == "editIncomeSegue"{
            if let indexPath = incomeTableView.indexPathForSelectedRow{
                let editIncomeVC = segue.destination as? EditIncomeViewController
                editIncomeVC?.type = currentDateIncomeArray[indexPath.row].type
                editIncomeVC?.index = indexPath
                
                var count = 0
                for income in allIncomeArray{
                    if income.money == currentDateIncomeArray[indexPath.row].money &&
                        income.type == currentDateIncomeArray[indexPath.row].type &&
                        income.date == currentDateIncomeArray[indexPath.row].date {
                        break
                    }
                    count += 1
                }
                editIncomeVC?.count = count
                
                editIncomeVC?.setupEditType()
                editIncomeVC?.typeDropDownMenu.menuText = currentDateIncomeArray[indexPath.row].type
                editIncomeVC?.moneyTextfield.text = String(currentDateIncomeArray[indexPath.row].money)
            }
        }
    }
    
    func saveIncome(){
        do{
            if context.hasChanges{
                try context.save()
            }
        }
        catch{
            print("Error saving context \(error)")
        }
    }
    func loadIncome(){
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        do{
            allIncomeArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
    }
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }
}

//  tableView
extension IncomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - Tableview Datasource Methods
    //  tableView 的列數等於 moneyArray
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDateIncomeArray.count
    }
    //  重複使用列數
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = incomeTableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)
        let income = currentDateIncomeArray[indexPath.row]
        if let type = income.type{
            cell.textLabel?.text = "\t類型：\(type)"
        }
        if let incomeMoney = formatter.string(from: NSNumber(value: income.money)){
            cell.detailTextLabel?.text = incomeMoney
        }
        return cell
    }
    //MARK: - Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        incomeTableView.deselectRow(at: indexPath, animated: true)
    }
    //  在 tableView 上往左滑可以刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            for income in allIncomeArray{
                if currentDateIncomeArray[indexPath.row] == income{
                    context.delete(income)
                }
            }
            saveIncome()
            currentDateIncomeArray.remove(at: indexPath.row)
            incomeTableView.deleteRows(at: [indexPath], with: .fade)
            var todayMoney: Int64 = 0
            for income in currentDateIncomeArray{
                todayMoney += income.money
            }
            if let todayMoney = formatter.string(from: NSNumber(value: todayMoney)){
                totalIcomeLabel.text = "\(todayMoney)"
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}


