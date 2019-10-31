//
//  User.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/30/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper
import Firebase

struct UserModel: Decodable {
    var first_name: String!
    var last_name: String!
    var uid: String!
    
    static func fetchData(completion: @escaping (UserModel?, Error?) -> Void) {
        let currentUser = Auth.auth().currentUser
        if let currentUser = currentUser {
            let uid = currentUser.uid
            let db = Firestore.firestore()
            db.collection("users").document(uid).getDocument {(document, err) in
                if err != nil {
                    completion(nil, err)
                } else if document != nil && document!.exists {
                    if let userProfile = UserModel(JSON: document!.data()!) {
                        let user = userProfile
                        completion(user, nil)
                    }
                }
            }
        }
    }
}

extension UserModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        uid <- map["uid"]
    }
    
    
}
