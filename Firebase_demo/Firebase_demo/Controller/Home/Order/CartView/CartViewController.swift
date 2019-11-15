
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
    var totalPayment: Double = 0
    
    var bill: BillModel? {
        didSet {
            cartTableView.reloadData()
            totalPayment = bill!.getTotalPayment()
            if totalPayment == 0 {
                totalPaymentLabel.text = ""
            } else {
                totalPaymentLabel.text = totalPayment.splittedByThousandUnits()
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
    
    deinit {
        logger()
    }
    
    @IBAction func handleOrderTapped(_ sender: Any) {
        if let _ = delegate?.table {
            BillModel.checkOutBill(forTable: delegate!.table!) { [weak self] err in
                guard let strongSelf = self else { return }
                if err != nil {
                    print("CartViewController: Error Checking out Bill \(String(describing: strongSelf.bill?.id)) \(err!.localizedDescription)")
                } else {
                    strongSelf.delegate!.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
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
