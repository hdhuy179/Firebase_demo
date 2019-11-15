//
//  Date+.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/20/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

extension Date {
    func convertToString(withDateFormat dateFormat: String? = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func getDateFormatted(withDateFormat dateFormat: String? = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self.convertToString(withDateFormat: dateFormat))
    }
    
    static func getDate(fromString date: String, withDateFormat dateFormat: String? = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: date)
    }
}
