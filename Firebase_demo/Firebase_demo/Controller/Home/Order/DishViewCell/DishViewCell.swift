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
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    weak var delegate: OrderViewController?
    
    var dish: DishModel! {
        didSet {
            setupView()
        }
    }
    
    var amount: Int! = 0 {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        dishAmountLabel.text = String(amount)
        if amount == 0 {
            dishAmountLabel.alpha = 0
            minusButton.alpha = 0
        } else {
            dishAmountLabel.alpha = 1
            minusButton.alpha = 1
        }
    }
    
    func setupView() {
        if let imageURL = dish.image_url, let url = URL(string: imageURL) {
            dishProfileImage.loadImage(from: url)
        }
        dishNameLabel.text = dish.name
        dishUnitLabel.text = dish.unit
        if let price = dish.price {
            dishPriceLabel.text = price.splittedByThousandUnits()
        }
    }

    @IBAction func handlePlusButtonTapped(_ sender: Any) {
        amount += 1
        delegate?.changeOrderAmount(dish: dish, amount: amount)
        updateView()
    }
    
    @IBAction func handleMinusButtonTapped(_ sender: Any) {
        if amount > 0 {
            amount -= 1
        }
        delegate?.changeOrderAmount(dish: dish, amount: amount)
        updateView()
    }
}
