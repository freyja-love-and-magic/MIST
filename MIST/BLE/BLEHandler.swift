//
//  BLEHandler.swift
//  MIST
//
//  Created by Zach Babb on 1/16/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEHandler {
    
    static var shared = BLEHandler()
    static var isCheckout = false
    
    weak var peripheral: BLETwoWayPeripheral?
    var viewController: BLEViewController?
    
    private init() {
        
    }
    
    public func setPeripheral(_ peripheral: BLETwoWayPeripheral) {
        self.peripheral = peripheral
        peripheral.readCallback = readHandler
        peripheral.writeCallback = writeHandler(_:_:)
        peripheral.notifyCallback = notifyHandler
    }
    
    private func readHandler() -> String {
        print("received read request")
        viewController?.log("received read request")
        return BLEHandler.isCheckout ? "Checkout" : "Ready"
    }
    
    private func writeHandler(_ value: String, _ central: CBCentral) {
        print("Should write value")
        print("With value \(value)")
        DispatchQueue.main.async {
            self.viewController?.log("Should write value \(value)")
            self.viewController?.respondToValue(value)
            
        }
    }
    
    private func notifyHandler() -> String {
        print("Should notify value")
        viewController?.log("Should notify value")
        return ""
    }
    
    private func writeValue(value: String) {
        print("IS this needed?")
    }
}
