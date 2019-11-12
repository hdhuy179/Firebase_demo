//
//  DishCategoryModel.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/4/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper
import Firebase

struct DishCategoryModel: Decodable {
    var id: String!
    var name: String? = ""
    
    static func fetchAllDishCategory(completion: @escaping ([DishCategoryModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        var dishCategories = [DishCategoryModel]()
        db.collection("dishCategory").order(by: "name").getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err)
            } else if snapshot?.documents != nil {
                snapshot!.documents.forEach({ (document) in
                    if let dishCategory = DishCategoryModel(JSON: document.data()) {
                        dishCategories.append(dishCategory)
                    }
                })
                completion(dishCategories, nil)
            }
        }
    }
}

extension DishCategoryModel: Hashable {
    static func == (lhs: DishCategoryModel, rhs: DishCategoryModel) -> Bool {
        return lhs.id == rhs.id 
    }
}

extension DishCategoryModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
    
}
