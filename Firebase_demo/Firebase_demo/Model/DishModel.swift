//
//  DishModel.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/31/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper
import Firebase

struct DishModel: Decodable {
    var id: String!
    var name: String? = ""
    var unit: String? = ""
    var price: Int? = 0
    var imageURL: String? = ""
    var categoryID: String? = ""
    
    func priceToString () -> String {
        if var price = self.price {
            var result = ""
            while price >= 1000 {
                price /= 1000
                result.append(".000")
            }
            return String(price) + result
        }
        return "Chưa cập nhật"
    }
    
    static func fetchAllDish(completion: @escaping ([DishModel]?, Error?) -> Void) {
        var dishes = [DishModel]()
        
        let db = Firestore.firestore()
        db.collection("dish").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil,err)
            } else if snapshot != nil {
                for document in snapshot!.documents {
                    if let dish = DishModel(JSON: document.data()) {
                        dishes.append(dish)
                    }
                }
                completion(dishes, nil)
            }
        }
    }
    static func fetchDish(byCategoryID categoryID: String ,completion: @escaping ([DishModel]?, Error?) -> Void) {
        var dishes = [DishModel]()
        
        let db = Firestore.firestore()
        db.collection("dish").whereField("categoryID", isEqualTo: categoryID).order(by: "name").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil,err)
            } else if snapshot != nil {
                for document in snapshot!.documents {
                    if let dish = DishModel(JSON: document.data()) {
                        dishes.append(dish)
                    }
                }
                completion(dishes, nil)
            }
        }
    }
    
    static func fetchDish(byID id: String ,completion: @escaping (DishModel?, Error?) -> Void) {
        var dish = DishModel()
        let db = Firestore.firestore()
        db.collection("dish").document(id).getDocument { (snapshot, err) in
            if err != nil {
                completion(nil,err)
            } else if snapshot != nil {
                if let data = snapshot!.data() {
                    if let _ = DishModel(JSON: data) {
                        dish = DishModel(JSON: data)!
                    }
                }
            }
            completion(dish, nil)
        }
    }
}

extension DishModel: Hashable {
    static func == (element1: DishModel, element2: DishModel) -> Bool {
        if element1.id == element2.id {
            return true
        }
        return false
    }
}

extension DishModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        unit <- map["unit"]
        price <- map["price"]
        imageURL <- map["imageURL"]
        categoryID <- map["categoryID"]
    }
}
