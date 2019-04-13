//
//  AddExpenditureViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/4/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import IGLDropDownMenu

class AddExpenditureViewController: UIViewController {
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var typeTableView: UITableView!
    
    var typeArray = ["食", "衣", "住", "行", "育", "樂"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeTableView.isHidden = true
    }
    
    @IBAction func dropDownTypeButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.typeTableView.isHidden = !self.typeTableView.isHidden
        }
    }

}

extension AddExpenditureViewController: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - TableView Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = typeArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        typeButton.setTitle("\(typeArray[indexPath.row])", for: .normal)
        self.typeTableView.isHidden = !self.typeTableView.isHidden
    }
    
}
