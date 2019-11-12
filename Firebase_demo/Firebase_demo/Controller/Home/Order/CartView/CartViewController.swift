
//
//  CartViewController.swift
//  
//
//  Created by Hoang Dinh Huy on 10/24/19.
//

import UIKit

final class CartViewController: UIViewController {

    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    
    weak var delegate: OrderViewController?
    
    let cartCellHeight: CGFloat = 70.0
    let cartCellID = "CartViewCell"
    var totalPayment: Int = 0
    
    var bill: BillModel? {
        didSet {
            cartTableView.reloadData()
            totalPayment = 0
            if let orderList = bill!.order_list {
                orderList.forEach({ (order) in
                    if let price = order.dish.price, let amount = order.amount {
                        totalPayment += price * amount
                    }
                })
                if totalPayment == 0 {
                    totalPaymentLabel.text = ""
                } else {
                    totalPaymentLabel.text = totalPayment.thousandUnits()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        
        totalPaymentLabel.text = ""
        
        self.view.layer.cornerRadius = 12
        
        cartTableView.register(UINib(nibName: "CartViewCell", bundle: nil), forCellReuseIdentifier: cartCellID)
    }
    @IBAction func handleOrderTapped(_ sender: Any) {
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill?.order_list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: cartCellID, for: indexPath) as! CartViewCell
        cell.delegate = delegate
        cell.order = bill?.order_list?[indexPath.item]
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cartCellHeight
    }
}
