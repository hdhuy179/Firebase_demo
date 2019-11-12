//
//  TableModel.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/24/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper
import Firebase

struct TableModel: Decodable {
    // Database Variable
    var id: String!
    var number: String? = "000"
    var state: Int? = -1
    //Local Variable
    var bill: BillModel?
    
    static func fetchAllData(completion: @escaping ([TableModel]?, Error?) -> Void) {
        var tables = [TableModel]()
        let db = Firestore.firestore()
        
        db.collection("table").order(by: "state").getDocuments { (snapshot, err) in
            if err != nil {
                print("Error getting Table Data: \(err!.localizedDescription)")
                completion(nil, err)
            } else if snapshot != nil {
                snapshot!.documents.forEach({ (document) in
                    if let table = TableModel(JSON: document.data()) {
                        tables.append(table)
                    }
                })
                completion(tables, nil)
            }
        }
    }
}

extension TableModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        number <- map["number"]
        state <- map["state"]
    }
}
