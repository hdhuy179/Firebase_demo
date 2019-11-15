//
//  CartViewCell.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/25/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

final class CartViewCell: UITableViewCell {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishAmountLabel: UILabel!
    
    weak var delegate: OrderViewController?
    
    var order: OrderModel! {
        didSet {
            setupView()
        }
    }
    
    private var amount: Int = 0
    
    func setupView() {
        
        dishNameLabel.text = order.dish?.name
        if let price = order.dish?.price {
            dishPriceLabel.text = price.splittedByThousandUnits()
        }
        if let _ = order.amount {
            amount = order.amount!
            dishAmountLabel.text = String(order.amount!)
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        amount += 1
        dishAmountLabel.text = String(amount)
        delegate?.changeOrderAmount(dish: order.dish!, amount: amount)
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        if amount > 0 {
            amount -= 1
        }
        dishAmountLabel.text = String(amount)
        delegate?.changeOrderAmount(dish: order.dish!, amount: amount)
    }
}
