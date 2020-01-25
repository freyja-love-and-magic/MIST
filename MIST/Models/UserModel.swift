//
//  UserModel.swift
//  Planet Nine
//
//  Created by Zach Babb on 11/8/18.
//  Copyright © 2018 Planet Nine. All rights reserved.
//

import Foundation

struct User: Codable {
    var userId = 0
    var name = "name"
    var locationId = 1
    var powerId = 1
    var powerOrdinal = 0
    var power = 1000
    var lastPowerUsed = "2018-09-05T20:55:52.836Z"
    var powerRegenerationRate = 1.0
    var globalRegenerationRate = 1.66667
    var moveOrdinal = 0
    var lastMove = "2018-09-05T20:55:52.836Z"
    var ongoingRequest: String?
    var ongoingRequestTimestamp: String?
    var ongoingRequestPublicKey: String?
    var ongoingRequestSignature: String?
    var publicKey = ""
    var keys = [String: String]()
    var location = "1"
    var exits = [String: Int]()
    var nineum = [String]()
    var currentPower = 100
    var nextMove = "2018-09-05T20:55:52.836Z"
}

class UserModel {
    let defaults = UserDefaults.standard
    
    func getUser() -> User? {
        guard let jsonString = defaults.string(forKey: "user") else { return nil }
        let jsonData = jsonString.data(using: String.Encoding.utf8)
        var decodedUser = User()
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)
            decodedUser = try JSONDecoder().decode(User.self, from: jsonData!)
        } catch {
            print("Error getting user")
            print(error)
        }
        if decodedUser.userId == 0 {
            return nil
        }
        
        return decodedUser
    }
    
    func saveUser(user: User) {
        Utils().saveEncodableToDefaults(user, key: "user")
    }
    
    func saveUserFromJSON(user: String) {
        print("Saving from string")
        print(user)
        if user == "error" {
            return
        }
        //print(user)
        defaults.set(user, forKey: "user")
    }
    
    func clearUser() {
        defaults.set(nil, forKey: "user")
    }
}
