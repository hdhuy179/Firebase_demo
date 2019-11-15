//
//  User.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/30/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper
import Firebase

struct RestaurantStaffModel: Decodable {
    //Database Variable
    var uid: String!
    var first_name: String! = ""
    var last_name: String! = ""
    var address: String? = ""
    var phone: String? = ""
    var email: String? = ""
    var identifier_card: String? = ""
    
    static func fetchStaffData(completion: @escaping (RestaurantStaffModel?, Error?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            let db = Firestore.firestore()
            db.collection("restaurantStaff").document(uid).getDocument {(document, err) in
                if err != nil {
                    completion(nil, err)
                } else if document != nil && document!.exists {
                    if let staffProfile = RestaurantStaffModel(JSON: document!.data()!) {
                        let user = staffProfile
                        completion(user, nil)
                    }
                }
            }
        }
    }
}

extension RestaurantStaffModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        uid <- map["uid"]
        address <- map["address"]
        phone <- map["phone"]
        email <- map["email"]
        identifier_card <- map["identifier_card"]
    }
}
