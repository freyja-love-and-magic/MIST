//
//  GatewayModel.swift
//  MIST
//
//  Created by Zach Babb on 1/29/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation

struct MAGICGetUserGateway: Codable {
    let userId: Int
    let gatewayName: String
    let timestamp: String
    let signature: String
    func toString() -> String {
        return "{\"userId\":\(userId),\"gatewayName\":\"\(gatewayName)\",\"timestamp\":\"\(timestamp)\",\"signature\":\"\(signature)\"}"
    }
}

class GatewayModel {
    static func magicGetUserGateway(from json: String) -> MAGICGetUserGateway? {
        if let jsonData = json.data(using: .utf8) {
            var decodedGateway = MAGICGetUserGateway(userId: 0, gatewayName: "", timestamp: "", signature: "")
            do {
                decodedGateway = try JSONDecoder().decode(MAGICGetUserGateway.self, from: jsonData)
            } catch {
                print("Error getting gateway")
                print(error)
                return nil
            }
            return decodedGateway
        }
        return nil
    }
}
