//
//  BillTableViewCell.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/26/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableNameLabel: UILabel!
    @IBOutlet weak var totalBillLabel: UILabel!
    @IBOutlet weak var isPaidStateView: UIView!
    

    func blind(withBill bill: BillModel, ofTable table: TableModel) { //, byStaff staff: RestaurantStaffModel
        if let _ = table.number{
            tableNameLabel.text = "Bàn: \(table.number!) "
        }
//        if let _ = staff.first_name {
//            tableNameLabel.text! += "(\(staff.first_name!)"
//            if let _ = staff.last_name {
//                tableNameLabel.text! += "\(staff.last_name!))"
//            } else {
//                tableNameLabel.text! += ")"
//            }
//        }
        if let _ = bill.order_list {
            totalBillLabel.text = bill.getTotalPayment().splittedByThousandUnits()
        }
        
        if let _ = bill.is_paid {
            if bill.is_paid == true {
                isPaidStateView.alpha = 1
            } else {
                isPaidStateView.alpha = 0
            }
        }
    }
    
}
