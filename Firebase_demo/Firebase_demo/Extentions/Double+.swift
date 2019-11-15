//
//  Int+.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/12/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

extension Double {
    func splittedByThousandUnits() -> String {
        if self < 1000 {
            return String(format: "%.f", self)
        }
        var result = String(format: "%.f", self)
        var index = 3
        for _ in 1...result.count/3 {
            result.insert(".", at: result.index(result.endIndex, offsetBy: -index))
            index += 4
            if index == result.count {
                break
            }
        }
        return result
    }
}
