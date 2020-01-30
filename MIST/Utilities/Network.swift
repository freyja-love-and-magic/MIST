//
//  Network.swift
//  MIST
//
//  Created by Zach Babb on 1/19/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation

class Network {
    func get(path: String, callback: @escaping (Error?, Data?) -> Void) {
        let url = URL(string: "https://www.plnet9.com\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("getting url \(url)")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                callback(error, nil)
                return
            }
            if let data = data {
                callback(nil, data)
                return
            }
            callback(nil, nil)
        }.resume()
    }
    
    func getUser(callback: @escaping (Error?, Data?) -> Void) {
        print("getUser")
        let path = "/user/userId/41"
        get(path: path, callback: callback)
    }
    
    func getUserById(userId: Int, gatewayName: String, timestamp: String, signature: String, callback: @escaping (Error?, Data?) -> Void) {
        let path = "/user/userId/\(userId)/gateway/\(gatewayName)/signature/\(signature)/timestamp/\(timestamp)"
        get(path: path, callback: callback)
    }
}
