//
//  TableViewCell.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/18/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

final class TableViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var table: TableModel! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        if let size = table.size, let number = table.number {
            numberLabel.text = number
            sizeLabel.text = "S-\(size)"
        }
        switch table.bill?.isBillServed() {
        case nil:
            stateLabel.text = "Trống"
            stateLabel.backgroundColor =  UIColor.green
//        case 1:
//            stateLabel.text = "Đang yêu cầu thanh toán"
//            stateLabel.backgroundColor = UIColor.red
        case false:
            stateLabel.text = "Đang đợi món"
            stateLabel.backgroundColor = UIColor.orange
        case true:
            stateLabel.text = "Đang sử dụng"
            stateLabel.backgroundColor = UIColor.yellow
        default:
            stateLabel.text = "Unavailable"
            stateLabel.backgroundColor = UIColor.darkGray
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
