//
//  UIViewController+.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/14/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

extension UIViewController {
    func logger() {
        print(String(describing: type(of: self)) + " deinit")
    }
}
    //Mark: Activity Indicator

//Variable for Background View
fileprivate var backgroundView: UIView?

extension UIViewController {
    
    //Show Activity Indicator View function
    func showActivityIndicatorView() {
        
        //Ignore interaction events when showing Activity Indicator View
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Create Background View and Background color
        backgroundView = UIView(frame: self.view.bounds)
        backgroundView!.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        // Create Activity Indicator and start animation
        let aiview = UIActivityIndicatorView(style: .whiteLarge)
        aiview.center = backgroundView!.center
        aiview.startAnimating()
        backgroundView!.addSubview(aiview)
        self.view.addSubview(backgroundView!)
        // If The Activity Indicator View appeared over 20 second then we put The View back to Main View
//        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { (timer) in
//            if backgroundView != nil {
//                // Do something in here
//            }
//        }
    }
    
    // Hide Activity Indicator View function
    func hideActivityIndicatorView() {
        
        // Remove Activity Indicator View From Superview
        backgroundView?.removeFromSuperview()
        backgroundView = nil
        
        //End ignore interaction events when hiding Activity Indicator View
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
