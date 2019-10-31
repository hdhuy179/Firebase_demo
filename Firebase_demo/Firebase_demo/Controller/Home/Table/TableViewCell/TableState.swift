//
//  TableState.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/24/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

//import UIKit
//
//enum TableState: Int {
//    case unavailable
//    case available
//    case used
//    case waiting
//    case paying
//    
//    var databaseType: Int {
//        switch self {
//        case .unavailable:
//            return -1
//        case .available:
//            return 0
//        case .used:
//            return 1
//        case .waiting:
//            return 2
//        case .paying:
//            return 3
//        }
//    }
//    
//    var message: String {
//        switch self {
//        case .unavailable:
//            return "Unavailable"
//        case .available:
//            return "Trống"
//        case .used:
//            return "Đang sử dụng"
//        case .waiting:
//            return "Đang đợi món"
//        case .paying:
//            return "Đang yêu cầu thanh toán"
//        }
//    }
//    
//    func getColor() -> UIColor {
//        switch self {
//        case .unavailable:
//            return UIColor.darkGray
//        case .available:
//            return UIColor.green
//        case .used:
//            return UIColor.yellow
//        case .waiting:
//            return UIColor.orange
//        case .paying:
//            return UIColor.red
//        }
//    }
//    
//    func getState(state: Int) -> TableState {
//        switch state {
//            case 0:
//                return .available
//            case 1:
//                return .used
//            case 2:
//                return .waiting
//            case 3:
//                return .paying
//            default:
//                return .unavailable
//        
//        }
//    }
//}
