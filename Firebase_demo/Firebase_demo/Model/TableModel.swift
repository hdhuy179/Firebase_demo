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
    var id: String! = ""
    var number: String? = ""
    var size: Int? = 0
    // Local Variable
    var bill: BillModel?
    
    static func fetchAllTableData(completion: @escaping ([TableModel]?, Error?) -> Void) {
        var tables = [TableModel]()
        let db = Firestore.firestore()
        
        db.collection("table").order(by: "number").getDocuments { (snapshot, err) in
            if err != nil {
                print("Error getting Table Data: \(err!.localizedDescription)")
                completion(nil, err)
            } else if snapshot != nil, !snapshot!.documents.isEmpty {
                snapshot!.documents.forEach({ (document) in
                    if let table = TableModel(JSON: document.data()) {
                        tables.append(table)
                    }
                })
                tables.enumerated().forEach { (index, table) in
                    BillModel.fetchCurrentBill(ofTableID: table.id!) { (bill, err) in
                        if err != nil {
                            print("TableViewController: Error getting Bill Data \(err!.localizedDescription)")
                        } else {
                            tables[index].bill = bill
                        }
                        if !tables.contains(where: { (table) -> Bool in
                            if table.bill == nil {
                                return true
                            }
                            return false
                        }) {
                            completion(tables, nil)
                        }
                    }
                }
            } else {
                completion(tables, nil)
            }
        }
    }
}

extension TableModel: Hashable {
    static func == (lhs: TableModel, rhs: TableModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TableModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        number <- map["number"]
        size <- map["size"]
    }
}
