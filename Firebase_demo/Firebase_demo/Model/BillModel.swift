//
//  BillModel.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/7/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper
import Firebase

//enum bill: String {
//    case id
//    case customerName
//    case isPaid
//    case orderList
//    case tableID
//    case userID
//    typealias RawValue = String
//}

struct BillModel: Decodable {
    var id: String!
    var customer_name: String? = ""
    var is_paid: Bool? = false
    var order_list: [OrderModel]?
    var table_id: String? = ""
    var restaurant_staff_id: String? = ""
//    var created_date: Date? = Date()
    
    func isBillServed() -> Bool? {
        if let orderList = order_list {
            for order in orderList {
                if !order.checkOrderServed() {
                    return false
                }
            }
            return true
        }
        return nil
    }
    
    mutating func addOrder(withDish dish: DishModel, amount: Int) {
        if let _ = order_list {
            for (index, order) in order_list!.enumerated() {
                if order.dish == dish {
                    if let _ = order_list![index].amount {
                        if amount == 0 {
                            order_list!.remove(at: index)
                            return
                        }
                        order_list![index].amount! = amount
                        return
                    }
                }
            }
            let order = OrderModel(id: UUID().uuidString, dish: dish, amount: amount, served_amount: 0)
            order_list!.append(order)
            return
        }
        order_list = [OrderModel]()
        let order = OrderModel(id: UUID().uuidString, dish: dish, amount: amount, served_amount: 0)
        order_list!.append(order)
    }
    
    static func fetchCurrentBill(ofTableID tableID: String,completion: @escaping (BillModel?, Error?) -> Void) {
        var bill = BillModel()
        
        let db = Firestore.firestore()
        
        db.collection("bill").whereField("table_id", isEqualTo: tableID).whereField("is_paid", isEqualTo: false).order(by: "created_date", descending: true).limit(to: 1).getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err!)
                
            } else if snapshot != nil {
                if let document = snapshot!.documents.first?.data() {
                    if let _ = BillModel(JSON: document) {
                        bill = BillModel(JSON: document)!
                    }
                    OrderModel.fetchAllOrder(byBillID: bill.id) { (orderList, err) in
                        if err != nil {
                            print("BillModel: Error getting Orders of Bill \(String(describing: bill.id)) \(err!.localizedDescription)")
                        } else if orderList != nil {
                            bill.order_list = orderList
                        }
                        completion(bill, nil)
                    }
                }
            }
        }
    }
}

extension BillModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        customer_name <- map["customer_name"]
        is_paid <- map["is_paid"]
        table_id <- map["table_id"]
        restaurant_staff_id <- map["restaurant_staff_id"]
        //created_date <- map["created_dates"]
    }
}
