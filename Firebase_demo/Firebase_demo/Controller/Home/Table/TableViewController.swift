//
//  HomeViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/14/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

final class TableViewController: UIViewController {

    @IBOutlet weak var leftTableCollectionViewConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var tableCollectionView: UICollectionView!
    @IBOutlet weak var userProfileNameLabel: UILabel!
    
    
    var isMenuShowed: Bool!
    
    var user: UserModel!
    let tableCellID = "tableCellID"
    var tables = [TableModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showActivityIndicatorView()
        fetchData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            if self.user != nil && !self.tables.isEmpty {
                print("TableViewController: Data was fetched")
                self.setupView()
                self.hideActivityIndicatorView()
                timer.invalidate()
            }
        }
        
    }
    
    deinit {
        logger()
    }
    
    func fetchData() {
        UserModel.fetchData { (data, err) in
            if err != nil {
                print("Error getting User Data: \(err!.localizedDescription)")
            } else if data != nil {
                self.user = data!
            }
        }
        TableModel.fetchAllData { (data, err) in
            if err != nil {
                print("Error getting Table Data: \(err!.localizedDescription)")
            } else if data != nil {
                self.tables = data!
            }
        }
    }
    func setupView() {
        isMenuShowed = false
        userProfileNameLabel.text = "\(String(user.first_name)) \(String(user.last_name))"
        
//        tableCollectionView.reloadData()
               
        tableCollectionView.dataSource = self
        tableCollectionView.delegate = self
       
        tableCollectionView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellWithReuseIdentifier: tableCellID)
    }
    
    
    @IBAction func MenuBarTapped(_ sender: Any) {
        isMenuShowed = !isMenuShowed
        if isMenuShowed {
            leftTableCollectionViewConstrant.constant = view.frame.width/1.5
            
        } else {
            leftTableCollectionViewConstrant.constant = 0
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func handleLogOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.isLoggedIn = false
            App.shared.transitionToMainView()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

extension TableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tables.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tableCellID, for: indexPath) as! TableViewCell
        cell.table = tables[indexPath.item]
           return cell
       }
}

extension TableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2 - 20, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let table = tables[indexPath.item]
        switch table.state {
        case 0:
            let vc = UIStoryboard.OrderViewController
            vc.table = table
            App.shared.rootNagivationController.pushViewController(vc, animated: true)
        case 1,2:
            let vc = UIStoryboard.OrderManagerViewController
            vc.table = table
            App.shared.rootNagivationController.pushViewController(vc, animated: true)
        default: return
        }
       
        
    }
//    func showAlert(title: String, indexPath: IndexPath) {
//        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: { _ in
//            let vc = UIStoryboard.OrderViewController
//            vc.table = self.tables[indexPath.item]
//            App.shared.rootNagivationController.pushViewController(vc, animated: true)
//        }))
//        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Khác", style: .default, handler: nil))
//
//        App.shared.rootNagivationController.present(alert, animated: true, completion: nil)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let orderViewController = segue.destination as? OrderViewController {
//            orderViewController.table = tables[3]
//        }
//        print(tables[3].number)
//    }

}

extension TableViewController: UICollectionViewDelegate {
    
}

//var isMenuShowed: Bool!
//    let floorCellID = "floorCellID"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        
//        configView()
//    }
//    
//    deinit {
//        logger()
//    }
//    
//    func configView() {
//        isMenuShowed = false
//        leftMenuBarSideConstrant.constant = -view.frame.width/1.5
//        
//        tableCollectionView.delegate = self
//        tableCollectionView.dataSource = self
//        
//        tableCollectionView.register(UINib(nibName: "FloorViewCell", bundle: nil), forCellWithReuseIdentifier: floorCellID)
//    }
//    
//    
//    @IBAction func MenuBarTapped(_ sender: Any) {
//        isMenuShowed = !isMenuShowed
//        if isMenuShowed {
//            leftMenuBarSideConstrant.constant = 0
//            
//        } else {
//            leftMenuBarSideConstrant.constant = -view.frame.width/1.5
//        }
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
//
//}
//
//extension TableViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = tableCollectionView.dequeueReusableCell(withReuseIdentifier: floorCellID, for: indexPath) as! FloorViewCell
//        return cell
//    }
//}
//
//extension TableViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.size.height)
//    }
//}
//
//extension TableViewController: UICollectionViewDelegate {
//    
//}
