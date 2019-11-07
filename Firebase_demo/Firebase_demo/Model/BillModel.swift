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
    var table_number: String? = ""
    var restaurant_staff_id: String? = ""
//    var created_date: Date? = Date()
    
    static func fetchCurrentBill(ofTableID tableNumber: String,completion: @escaping (BillModel?, Error?) -> Void) {
        var bill = BillModel()
        
        let db = Firestore.firestore()
        
        db.collection("bill").whereField("table_number", isEqualTo: tableNumber).whereField("is_paid", isEqualTo: false).order(by: "created_date", descending: true).limit(to: 1).getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err!)
            } else if snapshot != nil {
                if let document = snapshot!.documents.first?.data() {
                    if let _ = BillModel(JSON: document) {
                        bill = BillModel(JSON: document)!
                    }
                }
                
                OrderModel.fetchAllOrder(byBillID: bill.id) { (orderList, err) in
                    if err != nil {
                        print("BillModel: Error getting Orders of Bill \(String(describing: bill.id)) \(err!.localizedDescription)")
                    } else if orderList != nil {
                        bill.order_list = orderList
                    }
                }
                completion(bill, nil)
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
        table_number <- map["table_number"]
        restaurant_staff_id <- map["restaurant_staff_id"]
        //created_date <- map["created_dates"]
    }
}
