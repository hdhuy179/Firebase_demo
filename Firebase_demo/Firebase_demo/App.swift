//
//  App.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/15/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

final class App: UINavigationController {
    static let shared = App()
    
    var window: UIWindow!
    var rootNagivationController = RootNavigationController()
    
//    let mainViewController = UIStoryboard.MainViewController
//    let homeViewController = UIStoryboard.HomeViewController
//    let loginViewController = UIStoryboard.LoginViewController
//    let signUpViewController = UIStoryboard.SignUpViewController
    
    func startInterface() {
        if let isLoggedIn = UserDefaults.standard.isLoggedIn, isLoggedIn == false {
            self.window.rootViewController = UIStoryboard.MainViewController
        } else {
            self.window.rootViewController = rootNagivationController
        }
        window.makeKeyAndVisible()
    }
    
    func transitionToMainView() {
        rootNagivationController = RootNavigationController()
        changeView(UIStoryboard.MainViewController)
    }
    
    func transitionToTableView() {
        changeView(rootNagivationController)
    }
    
    func changeView(_ viewController: UIViewController) {
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = viewController
        }, completion: nil)
//        present(viewController, animated: true, completion: nil)
    }
}
