//
//  ManageViewCell.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/3/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

class OrderManagerViewCell: UITableViewCell {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var finishDishOrderButton: UIButton!

    weak var delegate: OrderManagerViewController?
    var order: OrderModel! {
           didSet {
               setupView()
           }
       }
    
    func setupView() {
        if let _ = order.dish.name, let _ = order.dish.price, let _ = order.amount, let _ = order.served_amount {
            dishNameLabel.text = "\(order.dish.name!)\n\(order.dish.price!.splittedByThousandUnits())"
            progressLabel.text = "\(order.served_amount!)/\(order.amount!)"
            if order.checkOrderServed() {
                finishDishOrderButton.isEnabled = false
                finishDishOrderButton.backgroundColor = .systemGray
            } else {
                finishDishOrderButton.isEnabled = true
                finishDishOrderButton.backgroundColor = .systemGreen
            }
        }
    }
    
    @IBAction func handleFinishDishOrder(_ sender: Any) {
        order.served_amount = order.amount
        delegate?.updateOrderTable(forOrder: order)
    }
}
