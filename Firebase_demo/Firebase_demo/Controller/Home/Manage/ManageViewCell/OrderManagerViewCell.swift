//
//  ManageViewCell.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/3/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

class OrderManagerViewCell: UITableViewCell {

    @IBOutlet weak var finishDishOrderButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func handleFinishDishOrder(_ sender: Any) {
        finishDishOrderButton.isEnabled = false
        finishDishOrderButton.backgroundColor = .darkGray
        finishDishOrderButton.setTitleColor(.lightGray, for: .disabled)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
