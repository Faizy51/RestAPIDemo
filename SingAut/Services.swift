//
//  Services.swift
//  SingAut
//
//  Created by Faizyy on 11/04/20.
//  Copyright © 2020 faiz. All rights reserved.
//

import Foundation

enum ServiceType {
    case roomList
    case lockDetails
    
    var url: String {
        switch self {
        case .roomList:
            return "https://api.snglty.com/v1/test/roomsList"
        case .lockDetails:
            return "https://api.snglty.com/v1/test/lockDetails"
        }
    }
}

class Services {
    
    func formJsonRequest(ofType service: ServiceType, forRoom id: Int?) -> URLRequest {
        let timeStamp = Date.currentTimeStamp
        let baseUrl = service.url
        var urlByAppendingTimeStamp: String?
        
        if service == .roomList {
            urlByAppendingTimeStamp = "\(baseUrl)?timestamp=\(timeStamp)"
        }
        else {
            if let roomId = id {
                urlByAppendingTimeStamp = "\(baseUrl)?roomId=\(roomId)&timestamp=\(timeStamp)"
            }
        }
        guard let urlString = urlByAppendingTimeStamp, let url = URL(string: urlString) else {
            assert(false, "Request cannot be created. Please check the url!")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }
    
    func downloadData(forType service: ServiceType, withRoom id: Int?, handler: @escaping (Any?)->()) {
        // Give me the request
        let request = formJsonRequest(ofType: service, forRoom: id)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                handler(nil)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            // Decode
            var roomList: RoomList?
            var lockDetails: LockDetails?
            do {
                if service == .roomList {
                    roomList = try JSONDecoder().decode(RoomList.self, from: data)
                    handler(roomList?.data)
                }
                else {
                    print("Data recieved")
                    lockDetails = try JSONDecoder().decode(LockDetails.self, from: data)
                    print("lock details recieved : \(lockDetails)")
                    handler(lockDetails)
                }
            }
            catch let err {
                print(err.localizedDescription)
            }
        }.resume()
    }
    
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970)
    }
}
