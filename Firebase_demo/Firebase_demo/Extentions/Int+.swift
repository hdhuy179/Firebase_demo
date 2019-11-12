//
//  Int+.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/12/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

extension Int {
    func thousandUnits() -> String {
        var price = self
        var result = ""
        while price >= 1000 {
            price /= 1000
            result.append(".000")
        }
        return String(price) + result
    }
}
