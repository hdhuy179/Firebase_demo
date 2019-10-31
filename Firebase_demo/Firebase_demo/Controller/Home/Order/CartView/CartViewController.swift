
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
    @IBOutlet weak var totalPayment: UILabel!
    
    let cartCellHeight: CGFloat = 70.0
    let cartCellID = "CartViewCell"
    
    var dishes: [DishModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        
        self.view.layer.cornerRadius = 12
        
        self.dishes = [DishModel]()
        
        cartTableView.register(UINib(nibName: "CartViewCell", bundle: nil), forCellReuseIdentifier: cartCellID)
        
        
    }
    @IBAction func handleOrderTapped(_ sender: Any) {
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: cartCellID, for: indexPath) as! CartViewCell
        cell.dish = dishes[indexPath.item]
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cartCellHeight
    }
}
