//
//  BillHistoryTabBarViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/25/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

class BillHistoryTabBarViewController: UITabBarController {

    var tables: [TableModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
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

extension BillHistoryTabBarViewController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
//    }
//
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is PeriodBillHistoryViewController {
//            let vc = viewController as? PeriodBillHistoryViewController
//            vc?.tables = tables
//        }
//        return true
//    }
}
