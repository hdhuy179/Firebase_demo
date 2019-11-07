//
//  OrderModel.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/7/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper
import Firebase

//enum order: String {
//    case id = "id"
//    case dishID = "dishID"
//    case amount = "amount"
//    case serverdAmount = "serverdAmount"
//}

struct OrderModel: Decodable {
    var id: String!
    var dish_name: String? = ""
    var dish_price: Int? = 0
    var amount: Int? = 1
    var served_amount: Int? = 0
    
    static func fetchAllOrder(byBillID billID: String, completion: @escaping ([OrderModel]?, Error?) -> Void) {
        var orders = [OrderModel]()
        let db = Firestore.firestore()
    db.collection("bill").document(billID).collection("order").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err)
            } else if snapshot != nil {
                snapshot!.documents.forEach({ (document) in
                    if let order = OrderModel(JSON: document.data()) {
                        orders.append(order)
                    }
                })
                completion(orders, nil)
            }
        }
    }
}

extension OrderModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        dish_name <- map["dish_name"]
        dish_price <- map["dish_price"]
        amount <- map["amount"]
        served_amount <- map["served_amount"]
    }
}
