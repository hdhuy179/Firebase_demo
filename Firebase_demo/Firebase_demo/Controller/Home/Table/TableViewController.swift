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

protocol TableViewControllerDelegate: class {
}

final class TableViewController: UIViewController {

    @IBOutlet weak var leftTableCollectionViewConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var tableCollectionView: UICollectionView!
    @IBOutlet weak var userProfileNameLabel: UILabel!
    
    
    var isMenuShowed: Bool! = false
    
    var restaurantStaff: RestaurantStaffModel!
    let tableCellID = "tableCellID"
    var tables = [TableModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        fetchData()
    }
    
    deinit {
        logger()
    }
    
    func fetchData() {
        self.showActivityIndicatorView()
        RestaurantStaffModel.fetchUserData {[weak self] data, err in
            guard let strongSelf = self else { return }
            if err != nil {
                print("TableViewController: Error getting Restaurant Staff Data: \(err!.localizedDescription)")
            } else if data != nil {
                strongSelf.restaurantStaff = data!
                
                TableModel.fetchAllTableData { [weak self] data, err in
                    guard let strongSelf = self else { return }
                    if err != nil {
                        print("TableViewController: Error getting Table Data: \(err!.localizedDescription)")
                    } else {
                        strongSelf.tables = data!
                    }
                    strongSelf.setupData()
                }
            }
        }
    }
    func setupData() {
        userProfileNameLabel.text = "\(String(restaurantStaff.first_name)) \(String(restaurantStaff.last_name))"
        self.tableCollectionView.reloadData()
        self.hideActivityIndicatorView()
        print("TableViewController: Data was fetched")
    }
    
    func setupView() {
        isMenuShowed = false
               
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
        if table.bill?.order_list == nil {
            let vc = UIStoryboard.OrderViewController
            vc.table = table
            vc.delegate = self
            App.shared.rootNagivationController.pushViewController(vc, animated: true)
            return
        }
        
        let vc = UIStoryboard.OrderManagerViewController
        vc.table = table
        vc.delegate = self
        App.shared.rootNagivationController.pushViewController(vc, animated: true)
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

extension TableViewController: TableViewControllerDelegate {
    
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
