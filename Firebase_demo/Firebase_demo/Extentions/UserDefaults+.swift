//
//  UserDefaults+.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/15/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import Foundation

extension UserDefaults {
    // Variable to check the user is logged in or not
    var isLoggedIn: Bool? {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
