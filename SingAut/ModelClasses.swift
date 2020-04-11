//
//  ModelClasses.swift
//  SingAut
//
//  Created by Faizyy on 11/04/20.
//  Copyright © 2020 faiz. All rights reserved.
//

import Foundation



struct RoomList: Codable {
    var data: [RoomData]
    var success: Bool
}
struct RoomData: Codable {
    var org: Details
    var property: Details
    var room: Details
}
struct Details: Codable {
    var id : Int
    var name: String
}



struct LockDetails: Codable {
    var MAC: String
    var name: String
    var success: Bool
}
