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
    
    var order: OrderModel! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        dishNameLabel.text = order.dish_id.name
        dishPriceLabel.text = dish.priceToString()
        
        dishAmountLabel.text = "1"
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
    }
}
