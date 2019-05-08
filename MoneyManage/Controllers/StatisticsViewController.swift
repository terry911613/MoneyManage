//
//  StatisticsViewController.swift
//  MoneyManage
//
//  Created by 李泰儀 on 2019/4/5.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Charts
import CoreData

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var typeSegmented: UISegmentedControl!
    @IBOutlet weak var timeSegmented: UISegmentedControl!
    var typeArray = ["食", "衣", "住", "行", "育", "樂"]
    let now = Date()
    let dateFormatter = DateFormatter()
    var today: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var allExpenditureArray = [Expenditure]()
    var allIncomeArray = [Income]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDate()
        loadExpenditure()
        loadIncome()
    }
    func getDate(){
        dateFormatter.dateStyle = .medium
        today = dateFormatter.string(from: now)
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
    func loadIncome(){
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        do{
            allIncomeArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
    }
    
    @IBAction func typeSegmented(_ sender: UISegmentedControl) {
        
    }
    @IBAction func timeSegmented(_ sender: UISegmentedControl) {
        expenditurePieChart()
    }
    
    func expenditurePieChart() {
        let food = PieChartDataEntry(value: getFoodValue(), label: "food")
        let clothing = PieChartDataEntry(value: getClothingValue(), label: "clothing")
        let housing = PieChartDataEntry(value: getHousingValue(), label: "housing")
        let transportation = PieChartDataEntry(value: getTransportationValue(), label: "transportation")
        let education = PieChartDataEntry(value: getEducationValue(), label: "education")
        let entertainment = PieChartDataEntry(value: getEntertainmentValue(), label: "entertainment")
        
        let dataSet = PieChartDataSet(values: [food, clothing, housing, transportation, education, entertainment], label: "")
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
//        pieChartView.chartDescription?.text = "Share of Widgets by Type"
        // Color
        dataSet.colors = ChartColorTemplates.joyful()
        //dataSet.valueColors = [UIColor.black]
        pieChartView.backgroundColor = .white
        pieChartView.holeColor = UIColor.clear
        pieChartView.chartDescription?.textColor = UIColor.white
        pieChartView.legend.textColor = UIColor.white
        
        // Text
        pieChartView.legend.font = UIFont(name: "Futura", size: 10)!
        pieChartView.chartDescription?.font = UIFont(name: "Futura", size: 12)!
        pieChartView.chartDescription?.xOffset = pieChartView.frame.width
        pieChartView.chartDescription?.yOffset = pieChartView.frame.height * (2/3)
        pieChartView.chartDescription?.textAlign = NSTextAlignment.left
        
        // Refresh chart with new data
        pieChartView.notifyDataSetChanged()
    }
    func incomePieChart(){
        
    }
    
    func getFoodValue() -> Double{
        
        var totalMoney: Int64 = 0
        if timeSegmented.selectedSegmentIndex == 0{
            for expenditure in allExpenditureArray{
                if today == expenditure.date && expenditure.date == "食"{
                    totalMoney += expenditure.money
                }
            }
            return Double(totalMoney)
        }
        else if timeSegmented.selectedSegmentIndex == 1{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("May"){
                    if yes && expenditure.date == "食"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
        else{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("2019"){
                    if yes && expenditure.date == "食"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
    }
    func getClothingValue() -> Double{
        
        var totalMoney: Int64 = 0
        if timeSegmented.selectedSegmentIndex == 0{
            for expenditure in allExpenditureArray{
                if today == expenditure.date && expenditure.date == "衣"{
                    totalMoney += expenditure.money
                }
            }
            return Double(totalMoney)
        }
        else if timeSegmented.selectedSegmentIndex == 1{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("May"){
                    if yes && expenditure.date == "衣"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
        else{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("2019"){
                    if yes && expenditure.date == "衣"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
    }
    
    func getHousingValue() -> Double{
        
        var totalMoney: Int64 = 0
        if timeSegmented.selectedSegmentIndex == 0{
            for expenditure in allExpenditureArray{
                if today == expenditure.date && expenditure.date == "住"{
                    totalMoney += expenditure.money
                }
            }
            return Double(totalMoney)
        }
        else if timeSegmented.selectedSegmentIndex == 1{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("May"){
                    if yes && expenditure.date == "住"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
        else{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("2019"){
                    if yes && expenditure.date == "住"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
    }
    func getTransportationValue() -> Double{
        
        var totalMoney: Int64 = 0
        if timeSegmented.selectedSegmentIndex == 0{
            for expenditure in allExpenditureArray{
                if today == expenditure.date && expenditure.date == "行"{
                    totalMoney += expenditure.money
                }
            }
            return Double(totalMoney)
        }
        else if timeSegmented.selectedSegmentIndex == 1{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("May"){
                    if yes && expenditure.date == "行"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
        else{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("2019"){
                    if yes && expenditure.date == "行"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
    }
    func getEducationValue() -> Double{
        
        var totalMoney: Int64 = 0
        if timeSegmented.selectedSegmentIndex == 0{
            for expenditure in allExpenditureArray{
                if today == expenditure.date && expenditure.date == "育"{
                    totalMoney += expenditure.money
                }
            }
            return Double(totalMoney)
        }
        else if timeSegmented.selectedSegmentIndex == 1{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("May"){
                    if yes && expenditure.date == "育"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
        else{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("2019"){
                    if yes && expenditure.date == "育"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
    }
    func getEntertainmentValue() -> Double{
        
        var totalMoney: Int64 = 0
        if timeSegmented.selectedSegmentIndex == 0{
            for expenditure in allExpenditureArray{
                if today == expenditure.date && expenditure.date == "樂"{
                    totalMoney += expenditure.money
                }
            }
            return Double(totalMoney)
        }
        else if timeSegmented.selectedSegmentIndex == 1{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("May"){
                    if yes && expenditure.date == "樂"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
        else{
            for expenditure in allExpenditureArray{
                if let yes = expenditure.date?.contains("2019"){
                    if yes && expenditure.date == "樂"{
                        totalMoney += expenditure.money
                    }
                }
            }
            return Double(totalMoney)
        }
    }
}
