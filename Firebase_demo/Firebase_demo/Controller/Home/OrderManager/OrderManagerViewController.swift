//
//  ManageViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/3/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

protocol OrderManagerViewControllerDelegate: class {
    func updateOrderTable(forOrder order: OrderModel)
}

final class OrderManagerViewController: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    @IBOutlet weak var excessCashLabel: UILabel!
    @IBOutlet weak var guestMoneyTextField: UITextField!
    @IBOutlet weak var paymentButton: UIButton!
    
    weak var delegate: TableViewController?
    
    let orderCellHeight: CGFloat = 80.0
    var table: TableModel!
    
    let orderManagerViewCellID = "orderViewCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    deinit {
        logger()
    }
    
    func setupView() {
        addEndEditingTapGuesture()
        
        orderTableView.dataSource = self
        orderTableView.delegate = self
        
        if let table = table {
            navigationItem.title = " Bàn \(table.number!)"
            totalPaymentLabel.text = table.bill?.getTotalPayment().splittedByThousandUnits()
            excessCashLabel.text = ""
        }
        guestMoneyTextField.addTarget(self, action: #selector(changeGuestMoneyTextField(_:)), for: .editingChanged)
        paymentButton.isEnabled = false
        paymentButton.backgroundColor = .systemGray
        
        orderTableView.register(UINib(nibName: "OrderManagerViewCell", bundle: nil), forCellReuseIdentifier: orderManagerViewCellID)
    }
    
    @objc func changeGuestMoneyTextField(_ textField: UITextField) {
       
        var guestMoney = textField.text ?? ""
        guestMoney.removeAll(where: { (char) -> Bool in
            return char == "."
        })
         guestMoneyTextField.text = Double(guestMoney)?.splittedByThousandUnits()
        if Double(guestMoney) ?? 0 >= table.bill!.getTotalPayment() {
            paymentButton.isEnabled = true
            paymentButton.backgroundColor = .systemGreen
            let excessCash = Double(guestMoney)! - table.bill!.getTotalPayment()
            excessCashLabel.text = String(excessCash.splittedByThousandUnits())
        } else {
            excessCashLabel.text = ""
            paymentButton.isEnabled = false
            paymentButton.backgroundColor = .systemGray
        }
    }
    
    @IBAction func handlePaymentButtonTapped(_ sender: Any) {
        BillModel.getPaid(forTable: table) { [weak self] err in
            guard let strongSelf = self else { return }
            if err != nil {
                print("OrderManagerViewController: Bill \(String(describing: strongSelf.table.bill?.id)) is not paid")
            } else {
                App.shared.rootNagivationController.popViewController(animated: true)
            }
        }
    }
    
    @objc override func keyboardWillShow() {
        super.keyboardWillShow()
        if guestMoneyTextField.isEditing {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: -self.view.frame.height + self.guestMoneyTextField.frame.origin.y + self.guestMoneyTextField.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
        }
    }
    @objc override func keyboardWillHide() {
        super.keyboardWillHide()
        if guestMoneyTextField.isEditing {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            delegate?.fetchData()
//            delegate?.tableCollectionView.reloadData()
        }
    }
    
    @IBAction func orderMoreButtonTapped(_ sender: Any) {
        App.shared.rootNagivationController.popToRootViewController(animated: true)
        self.hideActivityIndicatorView()
        let vc = UIStoryboard.OrderViewController
        vc.table = table
        vc.delegate = delegate
        App.shared.rootNagivationController.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrderManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.bill?.order_list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderManagerViewCellID, for: indexPath) as! OrderManagerViewCell
        if let bill = table.bill {
            cell.order = bill.order_list![indexPath.item]
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let order = table.bill?.order_list?[indexPath.item] {
            showAlert(order) { [weak self] served_amount in
                guard let strongSelf = self else { return }
                strongSelf.table.bill!.order_list![indexPath.item].served_amount = served_amount
                strongSelf.updateOrderTable(forOrder: strongSelf.table.bill!.order_list![indexPath.item])
            }
        }
    }
    
    func showAlert(_ order: OrderModel, completion: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: order.dish.name, message: "đã giao \(order.served_amount!)/\(order.amount!)", preferredStyle: .alert)
                    alert.addTextField { (textField) in
                        textField.keyboardType = .numberPad
                    }
                    alert.addAction(UIAlertAction(title: "Đã giao thêm", style: .default, handler: { (action) in
                        guard let text = alert.textFields?.first?.text else { return }
                        if Int(text) == nil || Int(text)! > order.amount! {
                            let subAlert = UIAlertController(title: "Lỗi", message: "Hãy kiểm tra lại số lượng món", preferredStyle: .alert)
                            subAlert.addAction(UIAlertAction(title: "Oke", style: .destructive, handler: nil))
                            self.present(subAlert, animated: true, completion: nil)
                        } else {
                            completion(Int(text) ?? 0)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
    }
}

extension OrderManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return orderCellHeight
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            
        }
        let edit = UITableViewRowAction(style: .normal, title: "edit") { (action, indexPath) in
            
        }
        edit.backgroundColor = .orange
        return [delete, edit]
    }
}

extension OrderManagerViewController: OrderManagerViewControllerDelegate {
    
    func updateOrderTable(forOrder order: OrderModel) {
        self.showActivityIndicatorView()
        
        OrderModel.updateOrder(forTable: self.table, withOrder: order) { [weak self] newOrder, err  in
            guard let strongSelf = self else { return }
            if err != nil {
                print("BillModel: Error check out Bill \(strongSelf.table.bill!.id!) \(err!.localizedDescription)")
            } else if newOrder != nil{
                if let _ = strongSelf.table.bill?.order_list {
                    strongSelf.table.bill!.order_list!.enumerated().forEach { (index, element) in
                        if element == newOrder {
                            strongSelf.table.bill!.order_list![index].served_amount = newOrder!.served_amount
                            strongSelf.orderTableView.reloadData()
                            strongSelf.hideActivityIndicatorView()
                        }
                    }
                }
            }
        }
    }
}
