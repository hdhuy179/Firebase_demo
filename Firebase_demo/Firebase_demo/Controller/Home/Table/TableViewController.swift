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
    
    var visualEffectView: UIVisualEffectView!
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
        RestaurantStaffModel.fetchStaffData {[weak self] data, err in
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
    }
    
    func setupView() {
        isMenuShowed = false
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        tableCollectionView.addSubview(visualEffectView)
        visualEffectView.effect = UIBlurEffect(style: .dark)
        
        if !isMenuShowed {
            visualEffectView.isHidden = true
        }
        
        tableCollectionView.dataSource = self
        tableCollectionView.delegate = self
       
        tableCollectionView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellWithReuseIdentifier: tableCellID)
    }
    
    
    @IBAction func MenuBarTapped(_ sender: Any) {
        isMenuShowed = !isMenuShowed
        if isMenuShowed {
            leftTableCollectionViewConstrant.constant = view.frame.width/1.5
            self.visualEffectView.isHidden = false
            
        } else {
            leftTableCollectionViewConstrant.constant = 0
            self.visualEffectView.isHidden = true
        }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    @IBAction func makeTakeawayBillTapped(_ sender: Any) {
        let vc = UIStoryboard.OrderViewController
        vc.delegate = self
        vc.table = TableModel()
        App.shared.rootNagivationController.pushViewController(vc, animated: true)
//        let vc = UIStoryboard.TakeawayViewController
//        App.shared.rootNagivationController.pushViewController(vc, animated: true)
    }
    
    @IBAction func billHistoryTapped(_ sender: Any) {
        let vc = UIStoryboard.BillHistoryTabBarViewController
        var inUsedTable = [TableModel]()
        tables.forEach { (table) in
            if table.bill?.order_list != nil {
                inUsedTable.append(table)
            }
        }
        vc.tables = inUsedTable
        App.shared.rootNagivationController.pushViewController(vc, animated: true)
    }
        
    @IBAction func kitchenButtonTapped(_ sender: Any) {
        let vc = UIStoryboard.KitchenViewController
        App.shared.rootNagivationController.pushViewController(vc, animated: true)
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
}

extension TableViewController: UICollectionViewDelegate {
    
}

//extension TableViewController: TableViewControllerDelegate {
//    
//}
