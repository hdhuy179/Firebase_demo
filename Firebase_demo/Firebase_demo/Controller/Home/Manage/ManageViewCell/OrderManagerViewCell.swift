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
        if let _ = order.dish.name, let _ = order.amount, let _ = order.served_amount {
            dishNameLabel.text = order.dish.name
            progressLabel.text = "\(order.served_amount!)/\(order.amount!)"
            if order.checkOrderServed() {
                finishDishOrderButton.isEnabled = false
            }
        }
    }
    
    @IBAction func handleFinishDishOrder(_ sender: Any) {
//        finishDishOrderButton.isEnabled = false
//        finishDishOrderButton.backgroundColor = .darkGray
//        finishDishOrderButton.setTitleColor(.lightGray, for: .disabled)
        delegate?.updateOrderTable(forOrder: order, served_amount: order.amount!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
