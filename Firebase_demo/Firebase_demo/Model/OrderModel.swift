//
//  OrderModel.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/7/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper

struct OrderModel: Decodable {
    var id: String!
    var dish: DishModel? = DishModel()
    var amount: Int? = 1
    var servedAmount: Int? = 0
}

extension OrderModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        amount <- map["amount"]
        servedAmount <- map["servedAmount"]
        dish!.id <- map["DishID"]
        DishModel.fetchDish(byID: dish!.id) { (data, err) -> Void in
            if err != nil {
                print("OrderModel: Error getting Dish Data \(err!.localizedDescription)")
                return
            } else if data != nil {
                self.dish = data!
            }
        }
    }
    
    
}
