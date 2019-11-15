//
//  PeriodBillHistoryViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/25/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

final class PeriodBillHistoryViewController: UIViewController {

    @IBOutlet weak var startDatePickerTextField: UITextField!
    @IBOutlet weak var endDatePickerTextField: UITextField!
    @IBOutlet weak var searchBillButton: UIButton!
    @IBOutlet weak var billTableView: UITableView!
    
    let billTableCellID = "billTableCellID"
    
    let rowHeight: CGFloat = 80
    
    var tables: [TableModel]?
    var bills: [BillModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        addEndEditingTapGuesture()
        startDatePickerTextField.isDatePickerTextField()
        endDatePickerTextField.isDatePickerTextField()
        
        billTableView.delegate = self
        billTableView.dataSource = self
        
        searchBillButton.isEnabled = false
        searchBillButton.backgroundColor = .systemGray
        billTableView.register(UINib(nibName: "BillTableViewCell", bundle: nil), forCellReuseIdentifier: billTableCellID)
    }
    
    @IBAction func startDateTextFieldEditingDidEnd(_ sender: Any) {
        endDatePickerTextField.isDatePickerTextField(minimumDate: Date.getDate(fromString: startDatePickerTextField.text!, withDateFormat: "dd/MM/yyyy"))
        checkSearchBillEnable()
    }
    
    @IBAction func endDateTextFieldEditingDidEnd(_ sender: Any) {
        startDatePickerTextField.isDatePickerTextField(maximumDate: Date.getDate(fromString: endDatePickerTextField.text!, withDateFormat: "dd/MM/yyyy"))
        checkSearchBillEnable()
    }
    
    func checkSearchBillEnable() {
        if Date.getDate(fromString: startDatePickerTextField.text!, withDateFormat: "dd/MM/yyyy") != nil &&
        Date.getDate(fromString: endDatePickerTextField.text!, withDateFormat: "dd/MM/yyyy") != nil &&
        Date.getDate(fromString: startDatePickerTextField.text!, withDateFormat: "dd/MM/yyyy")!.timeIntervalSince1970 <= Date.getDate(fromString: endDatePickerTextField.text!, withDateFormat: "dd/MM/yyyy")!.timeIntervalSince1970 {
            searchBillButton.isEnabled = true
            searchBillButton.backgroundColor = .systemGreen
        } else {
            searchBillButton.isEnabled = false
            searchBillButton.backgroundColor = .systemGray
        }
    }
    
    @IBAction func searchBillButtonTapped(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PeriodBillHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: billTableCellID, for: indexPath) as! BillTableViewCell
        cell.blind(withBill: tables![indexPath.item].bill!, ofTable: tables![indexPath.item])
        return cell
    }


}

extension PeriodBillHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}
