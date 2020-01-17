//
//  BLEHandler.swift
//  MIST
//
//  Created by Zach Babb on 1/16/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation

class BLEHandler {
    
    weak var central: BLETwoWayCentral?
    
    init(_ central: BLETwoWayCentral) {
        self.central = central
        central.readCallback = readHandler(_:)
        central.writeCallback = writeHandler
        central.notifyCallback = notifyHandler(_:)
    }
    
    func readHandler(_ value: String) {
        print("Read value \(value)")
    }
    
    func writeHandler() {
        print("Value written")
    }
    
    func notifyHandler(_ value: String) {
        print("Notify value \(value)")
    }
    
    func writeValue(value: String) {
        central?.writeValue(value: value)
    }
}
