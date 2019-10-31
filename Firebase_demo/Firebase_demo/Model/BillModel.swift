//
//  BillModel.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/7/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//
import ObjectMapper

struct BillModel: Decodable {
    var id: String!
    var customerName: String? = ""
    var idPaid: Bool? = false
    var orderList: [DishModel: Int]?
    var tableID: String? = ""
    var userID: String? = ""
}

//extension BillModel: ma
