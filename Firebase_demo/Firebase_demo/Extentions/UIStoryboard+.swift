//
//  UIStoryboard.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/14/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

extension UIStoryboard {
    // Variable for Login Storyboard
    static var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    // Variable for Home Storyboard
    static var home: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
}

extension UIStoryboard {
    // Variable for Main View Controller
    static var MainViewController: MainViewController {
        guard let vc = UIStoryboard.login.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            fatalError("MainViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    //Variable for Sign Up View Controller
    static var SignUpViewController: SignUpViewController {
        guard let vc = UIStoryboard.login.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            fatalError("SignUpViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    //Variable for Login View Controller
    static var LoginViewController: LoginViewController {
        guard let vc = UIStoryboard.login.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            fatalError("LoginViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    // Variable for Table View Controller
    static var TableViewController: TableViewController {
        guard let vc = UIStoryboard.home.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController else {
            fatalError("TableViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    // Variable for Order View Controller
    static var OrderViewController: OrderViewController {
        guard let vc = UIStoryboard.home.instantiateViewController(withIdentifier: "OrderViewController") as? OrderViewController else {
            fatalError("OrderViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    //Variable for Order Manager View Controller
    static var OrderManagerViewController: OrderManagerViewController {
        guard let vc = UIStoryboard.home.instantiateViewController(withIdentifier: "OrderManagerViewController") as? OrderManagerViewController else {
            fatalError("OrderManagerViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    // Variable for Root Navigation Controller
    static var RootNavigationController: RootNavigationController {
        guard let vc = UIStoryboard.home.instantiateViewController(withIdentifier: "RootNavigationController") as? RootNavigationController else {
            fatalError("RootNavigationController couldn't be found in Storyboard file")
        }
        return vc
    }
}
