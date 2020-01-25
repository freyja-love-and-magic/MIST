//
//  Network.swift
//  MIST
//
//  Created by Zach Babb on 1/19/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation

class Network {
    func get(path: String, callback: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: "https://www.plnet9.com\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("getting url \(url)")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                callback(nil, error)
                return
            }
            if let data = data {
                callback(data, nil)
                return
            }
            callback(nil, nil)
        }.resume()
    }
    
    func getUser(callback: @escaping (Data?, Error?) -> Void) {
        print("getUser")
        let path = "/user/userId/41"
        get(path: path, callback: callback)
    }
}
