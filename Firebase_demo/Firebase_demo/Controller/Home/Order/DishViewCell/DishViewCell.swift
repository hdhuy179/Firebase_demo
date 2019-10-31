//
//  DishViewCell.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/23/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

final class DishViewCell: UITableViewCell {

    @IBOutlet weak var dishProfileImage: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishUnitLabel: UILabel!
    @IBOutlet weak var dishAmountLabel: UILabel!
    @IBOutlet weak var plusButtonLabel: UIButton!
    @IBOutlet weak var minusButtonLabel: UIButton!
    
    var dish: DishModel! {
        didSet {
            setupView()
        }
    }
    
    private var amount: Int = 0
    
    func setupView() {
        dishAmountLabel.alpha = 0
        minusButtonLabel.alpha = 0
        
        if let imageURL = dish.imageURL, let url = URL(string: imageURL) {
            dishProfileImage.loadImage(from: url)
        }
        dishNameLabel.text = dish.name
        dishUnitLabel.text = dish.unit
        dishPriceLabel.text = dish.priceToString()
    }

    @IBAction func handlePlusTap(_ sender: Any) {
        amount += 1
        dishAmountLabel.text = String(amount)
        dishAmountLabel.alpha = 1
        minusButtonLabel.alpha = 1
        
    }
    
    @IBAction func handleMinusTap(_ sender: Any) {
        if amount > 0 {
            amount -= 1
        }
        if amount == 0 {
            dishAmountLabel.alpha = 0
            minusButtonLabel.alpha = 0
        }
        dishAmountLabel.text = String(amount)
    }
    
}
