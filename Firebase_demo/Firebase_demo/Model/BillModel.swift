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
    var id: String! = UUID().uuidString
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
    
    func getTotalPayment() -> Double {
        var totalPayment = 0.0
        if let orderList = order_list {
            orderList.forEach({ (order) in
                if let price = order.dish.price, let amount = order.amount {
                    totalPayment += price * Double(amount)
                }
            })
        }
        return totalPayment
    }
    
    mutating func updateOrder(withDish dish: DishModel, amount: Int) {
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
            let order = OrderModel(amount: amount, served_amount: 0, dish: dish)
            order_list!.append(order)
            return
        }
        order_list = [OrderModel]()
        let order = OrderModel(amount: amount, served_amount: 0, dish: dish)
        order_list!.append(order)
    }
    
    static func fetchCurrentBill(ofTableID tableID: String, completion: @escaping (BillModel?, Error?) -> Void) {
        var bill = BillModel()
        
        let db = Firestore.firestore()
        //.order(by: "created_date", descending: true)
        db.collection("bill").whereField("table_id", isEqualTo: tableID).whereField("is_paid", isEqualTo: false).limit(to: 1).getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err!)
            } else if snapshot != nil, !snapshot!.documents.isEmpty {
                if let document = snapshot!.documents.first?.data() {
                    if let _ = BillModel(JSON: document) {
                        bill = BillModel(JSON: document)!
                        
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
            } else {
                completion(bill, nil)
            }
        }
    }
    
    static func checkOutBill(forTable table: TableModel, completion: @escaping (BillModel?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        if let _ = table.bill, let _ = table.bill!.id, let _ = table.id, let _ = table.bill!.is_paid, let _ = table.bill!.order_list {
            db.collection("bill").document(table.bill!.id!).setData(["id": table.bill!.id!, "table_id": table.id!, "is_paid": table.bill!.is_paid!]) { err in
                if err != nil {
                    completion(nil, err)
                    return
                } else {
                    print("BillModel: Update Bill \(table.bill!.id!) successful")
                }
            }
            table.bill!.order_list!.forEach({ order in
                if let _ = order.id, let _ = order.dish.id, let _ = order.amount, let _ = order.served_amount {
                    db.collection("bill").document(table.bill!.id!).collection("order").document(order.id!).setData(["id": order.id!, "dish_id": order.dish.id!, "amount": order.amount!, "served_amount": order.served_amount!]) { err in
                        if err != nil {
                            completion(nil, err)
                            return
                        } else {
                            print("BillModel: Update Order \(order.id!) successful")
                        }
                        if order == table.bill!.order_list!.last{
                            completion(table.bill!, nil)
                        }
                    }
                }
            })
        }
    }
    
//    static func updateBill(forTable table: TableModel, completion: @escaping (BillModel?, Error?) -> Void) {
//        let db = Firestore.firestore()
//        
//        if let _ = table.bill, let _ = table.bill!.id, let _ = table.id, let _ = table.bill!.is_paid, let _ = table.bill!.order_list {
//            db.collection("bill").document(table.bill!.id!).setData(["id": table.bill!.id!, "table_id": table.id!, "is_paid": table.bill!.is_paid!]) { err in
//                if err != nil {
//                    completion(nil, err)
//                    return
//                } else {
//                    print("BillModel: Update Bill \(table.bill!.id!) successful")
//                }
//            }
//            table.bill!.order_list!.forEach({ order in
//                if let _ = order.id, let _ = order.dish.id, let _ = order.amount, let _ = order.served_amount {
//                    db.collection("bill").document(table.bill!.id!).collection("order").document(order.id!).setData(["id": order.id!, "dish_id": order.dish.id!, "amount": order.amount!, "served_amount": order.served_amount!]) { err in
//                        if err != nil {
//                            completion(nil, err)
//                            return
//                        } else {
//                            print("BillModel: Update Order \(order.id!) successful")
//                        }
//                        if order == table.bill!.order_list!.last{
//                            completion(table.bill!, nil)
//                        }
//                    }
//                }
//            })
//        }
//    }
    
//    static func updateBill(ofTable table: TableModel) {
//        let db = Firestore.firestore()
//
//        if let _ = table.bill, let _ = table.bill!.id, let _ = table.id, let _ = table.bill!.is_paid, let _ = table.bill!.order_list {
//            db.collection("bill").document(table.bill!.id!).setData(["is_paid": table.bill!.is_paid!]){ err in
//            if err != nil {
//                print("BillModel: Error update Bill \(table.bill!.id!) \(err!.localizedDescription)")
//                return
//            } else {
//                print("BillModel: updated Bill \(table.bill!.id!) successful")
//                }
//            }
//
//            table.bill!.order_list!.forEach({ (order) in
//                if let _ = order.id, let _ = order.dish.id, let _ = order.amount, let _ = order.served_amount {
//                    db.collection("bill").document(table.bill!.id!).collection("order").document(order.id!).setData(["id": order.id!, "dish_id": order.dish.id!, "amount": order.amount!, "served_amount": order.served_amount!]) { err in
//                        if err != nil {
//                            print("BillModel: Error check out Order \(order.id!) \(err!.localizedDescription)")
//                            return
//                        } else {
//                            print("BillModel: Create Order \(order.id!) successful")
//                        }
//                    }
//                }
//            })
//        }
//    }
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
