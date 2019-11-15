//
//  ManageViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/3/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

protocol OrderManagerViewControllerDelegate: class {
    func updateOrderTable(forOrder order: OrderModel, served_amount: Int)
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
    
    var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    deinit {
        logger()
    }
    
    func setupView() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        observeKeyboardNotification()
        
        orderTableView.dataSource = self
        orderTableView.delegate = self
        
        if let table = table {
            navigationItem.title = " Bàn \(table.number!)"
            totalPaymentLabel.text = table.bill?.getTotalPayment().splittedByThousandUnits()
            excessCashLabel.text = ""
        }
        guestMoneyTextField.addTarget(self, action: #selector(changeGuestMoneyTextField(_:)), for: .editingChanged)
        paymentButton.isEnabled = false
        paymentButton.backgroundColor = .darkGray
        
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
            paymentButton.backgroundColor = .green
            let excessCash = Double(guestMoney)! - table.bill!.getTotalPayment()
            excessCashLabel.text = String(excessCash.splittedByThousandUnits())
        } else {
            excessCashLabel.text = ""
            paymentButton.isEnabled = false
            paymentButton.backgroundColor = .darkGray
        }
    }
    
    @IBAction func handlePaymentButtonTapped(_ sender: Any) {
        table.bill?.is_paid = true
        BillModel.checkOutBill(table: table) { (_, _) in
            App.shared.rootNagivationController.popViewController(animated: true)
        }
    }
    
    private func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow() {
        if guestMoneyTextField.isEditing {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: -self.view.frame.height + self.guestMoneyTextField.frame.origin.y + self.guestMoneyTextField.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
        }
        self.view.addGestureRecognizer(tapGesture!)
    }
    @objc func keyboardHide() {
        if guestMoneyTextField.isEditing {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
        }
        self.view.removeGestureRecognizer(tapGesture!)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            delegate?.fetchData()
//            delegate?.tableCollectionView.reloadData()
        }
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
                strongSelf.updateOrderTable(forOrder: strongSelf.table.bill!.order_list![indexPath.item], served_amount: served_amount)
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
    
    func updateOrderTable(forOrder order: OrderModel, served_amount: Int) {
        self.showActivityIndicatorView()
        if let _ = table.bill?.order_list {
            table.bill!.order_list!.enumerated().forEach { (index, element) in
                if element == order {
                    table.bill!.order_list![index].served_amount = served_amount
                }
            }
        }
        BillModel.checkOutBill(table: self.table) { (bill, err) in
            if err != nil {
                print("BillModel: Error check out Bill \(self.table.bill!.id!) \(err!.localizedDescription)")
            } else if bill != nil {
                self.table.bill = bill
            }
            self.orderTableView.reloadData()
            self.hideActivityIndicatorView()
        }
    }
}
