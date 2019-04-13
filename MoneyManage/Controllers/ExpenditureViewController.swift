//
//  FirstViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/4/4.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class ExpenditureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let array = ["100", "200", "300", "400", "500"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            self.navigationItem.title = self.dateChanged(sender: datePicker)
            
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    func dateChanged(sender: UIDatePicker) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale(identifier: "zh_CN")
        return dateFormatter.string(from: sender.date)
    }
    
    //MARK: - Tableview Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenditureCell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(array[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
