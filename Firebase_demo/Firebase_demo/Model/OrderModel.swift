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
    //Database Variable
    var id: String! = UUID().uuidString
    var amount: Int? = 1
    var served_amount: Int? = 0
    var dish_id: String? = ""
    //Local Variable
    var dish: DishModel!
    
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
        db.collection("bill").document(billID).collection("order")
            .getDocuments { (snapshot, err) in
                if err != nil {
                    completion(nil, err)
                } else if snapshot != nil, !snapshot!.documents.isEmpty {
                    snapshot!.documents.forEach { (document) in
                        if let order = OrderModel(JSON: document.data()) {
                            orders.append(order)
                        }
                    }
                    
                    orders.enumerated().forEach { (index, order) in
                        if let dishID = order.dish_id {
                            DishModel.fetchDish(byDishID: dishID) { (dish, err) in
                                if err != nil {
                                    completion(nil, err)
                                } else if dish != nil {
                                    orders[index].dish = dish!
                                }
//                                for order in orders {
//                                    if order.dish == nil {
//                                        break
//                                    }
//                                    completion(orders, nil)
//                                }
                                if !orders.contains(where: { (order) -> Bool in
                                    if order.dish == nil {
                                        return true
                                    }
                                    return false
                                }) {
                                    completion(orders, nil)
                                }
                            }
                        }
                    }
                    
                } else {
                    completion(nil, nil)
                }
            }
    }
    
    static func updateOrder(forTable table: TableModel, withOrder order: OrderModel, completion: @escaping (OrderModel?, Error?) -> Void) {
        let db = Firestore.firestore()
        if let _ = order.id, let _ = order.dish.id, let _ = order.amount, let _ = order.served_amount {
                db.collection("bill").document(table.bill!.id!)
                    .collection("order").document(order.id!)
                    .setData(["served_amount": order.served_amount!], merge: true) { err in
                        if err != nil {
                            completion(nil, err)
                        } else {
                            print("OrderModel: Update Order \(order.id!) successful")
                            completion(order, nil)
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
        dish_id <- map["dish_id"]
        amount <- map["amount"]
        served_amount <- map["served_amount"]
    }
}
