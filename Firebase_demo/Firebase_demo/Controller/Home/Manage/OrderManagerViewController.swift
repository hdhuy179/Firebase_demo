//
//  ManageViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/3/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

final class OrderManagerViewController: UIViewController {

    @IBOutlet weak var OrderTableView: UITableView!
    @IBOutlet weak var guestMoneyTextField: UITextField!
    
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
        
        OrderTableView.dataSource = self
        OrderTableView.delegate = self
        
        if let tableNumber = table.number {
            navigationItem.title = " Bàn \(tableNumber)"
        }
        OrderTableView.register(UINib(nibName: "OrderManagerViewCell", bundle: nil), forCellReuseIdentifier: orderManagerViewCellID)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderManagerViewCellID, for: indexPath) as! OrderManagerViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Cơm rang dưa bò", message: "đã giao 4/5", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Đã giao thêm", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension OrderManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return orderCellHeight
    }
}
