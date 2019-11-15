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
    var price: Double? = 0
    var image_url: String? = ""
    var category_id: String? = ""
    
    static func fetchAllDish(completion: @escaping ([DishModel]?, Error?) -> Void) {
        var dishes = [DishModel]()
        
        let db = Firestore.firestore()
        db.collection("dish").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil,err)
            } else if snapshot != nil {
                snapshot!.documents.forEach({ (document) in
                    if let dish = DishModel(JSON: document.data()) {
                        dishes.append(dish)
                    }
                })
                completion(dishes, nil)
            }
        }
    }
    static func fetchDishes(byCategoryID categoryID: String ,completion: @escaping ([DishModel]?, Error?) -> Void) {
        var dishes = [DishModel]()
        
        let db = Firestore.firestore()
        db.collection("dish").whereField("category_id", isEqualTo: categoryID).order(by: "price").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil,err)
            } else if snapshot != nil {
                snapshot!.documents.forEach({ (document) in
                    if let dish = DishModel(JSON: document.data()) {
                        dishes.append(dish)
                    }
                })
                completion(dishes, nil)
            }
        }
    }
    
    static func fetchDish(byDishID id: String ,completion: @escaping (DishModel?, Error?) -> Void) {
        var dish = DishModel()
        let db = Firestore.firestore()
        db.collection("dish").document(id).getDocument { (snapshot, err) in
            if err != nil {
                completion(nil,err)
            } else if snapshot != nil, snapshot!.exists {
                if let data = snapshot!.data() {
                    if let _ = DishModel(JSON: data) {
                        dish = DishModel(JSON: data)!
                    }
                }
                completion(dish, nil)
            }
        }
    }
}

extension DishModel: Hashable {
    static func == (lhs: DishModel, rhs: DishModel) -> Bool {
        return lhs.id == rhs.id
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
        image_url <- map["image_url"]
        category_id <- map["category_id"]
    }
}
