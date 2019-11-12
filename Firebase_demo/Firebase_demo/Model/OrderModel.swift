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
    var dish: DishModel = DishModel()
    var amount: Int? = 1
    var served_amount: Int? = 0
    
    func checkOrderServed() -> Bool {
        if let amount = amount, let served_amount = served_amount {
            if served_amount / amount == 1 {
                return true
            }
        }
        return false
    }
    
    static func fetchAllOrder(byBillID billID: String, completion: @escaping ([OrderModel]?, Error?) -> Void) {
        var orders = [OrderModel]()
        let db = Firestore.firestore()
    db.collection("bill").document(billID).collection("order").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err)
            } else if snapshot != nil {
                snapshot!.documents.forEach { document in
                    if var order = OrderModel(JSON: document.data()) {
                        DishModel.fetchDish(byDishID: order.dish.id) { (data, err) in
                            if err != nil {
                                print("OrderModel: Error getting Dish data \(err!.localizedDescription)")
                            } else if data != nil {
                                order.dish = data!
                            }
                            orders.append(order)
                            if (document == snapshot!.documents.last) {
                                completion(orders, nil)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension OrderModel: Hashable {
    static func == (lhs: OrderModel, rhs: OrderModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OrderModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        dish.id <- map["dish_id"]
        amount <- map["amount"]
        served_amount <- map["served_amount"]
    }
}
