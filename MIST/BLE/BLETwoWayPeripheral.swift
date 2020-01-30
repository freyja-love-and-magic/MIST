//
//  BLETwoWayPeripheral.swift
//  PlanetNineGateway
//
//  Created by Zach Babb on 2/6/19.
//  Copyright © 2019 Planet Nine. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLETwoWayPeripheral: NSObject, CBPeripheralManagerDelegate {
    
    var manager: CBPeripheralManager
    var services: [CBService]
    var characteristics: [CBCharacteristic]
    var readCallback: (() -> String)?
    var writeCallback: ((String, CBCentral) -> Void)?
    var notifyCallback: (() -> String)?
    var centrals: [CBCentral]
    let uuids = bleCharacteristics()
    
    override init() {
        manager = CBPeripheralManager()
        services = [CBService]()
        characteristics = [CBCharacteristic]()
        centrals = [CBCentral]()
        
        super.init()
        manager.delegate = self

    }
    
    init(readCallback: @escaping () -> String, writeCallback: @escaping (String, CBCentral) -> Void, notifyCallback: @escaping () -> String) {
        manager = CBPeripheralManager()
        services = [CBService]()
        characteristics = [CBCharacteristic]()
        centrals = [CBCentral]()
        
        super.init()
        manager.delegate = self
        self.readCallback = readCallback
        self.writeCallback = writeCallback
        self.notifyCallback = notifyCallback
    }
    
    func setCallbacks(readCallback: @escaping () -> String, writeCallback: @escaping (String, CBCentral) -> Void, notifyCallback: @escaping () -> String) {
        self.readCallback = readCallback
        self.writeCallback = writeCallback
        self.notifyCallback = notifyCallback
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            print("Off")
        case .poweredOn:
            print("peripheral powered on")
            createServicesAndStartAdvertising()
        case .resetting:
            print("Resetting")
        case .unauthorized:
            print("Unauthorized")
        case .unknown:
            print("Unknown")
        case .unsupported:
            print("Unsupported")
        default:
            print("Got to the default somehow")
        }
    }
    
    func createServicesAndStartAdvertising() {
        let service = CBMutableService(type: bleServices().twoWay, primary: true)
        let readCharacteristic = CBMutableCharacteristic(type: bleCharacteristics().read, properties: .read, value: nil, permissions: .readable)
        let writeCharacteristic = CBMutableCharacteristic(type: bleCharacteristics().write, properties: .write, value: nil, permissions: .writeable)
        let notifyCharacteristic = CBMutableCharacteristic(type: bleCharacteristics().notify, properties: .notify, value: nil, permissions: .readable)
        
        characteristics.append(readCharacteristic)
        characteristics.append(writeCharacteristic)
        characteristics.append(notifyCharacteristic)
        
        service.characteristics = characteristics
        services.append(service)
        
        manager.add(service)
        
        manager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [service.uuid],
            CBAdvertisementDataLocalNameKey: "MIST" // Put unique names here 
        ])
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("Did receive read request")
        if request.characteristic.uuid == uuids.read {
            if let responseString = readCallback?() {
                print(responseString)
                print(responseString.count)
                let response = responseString.data(using: .utf8)
                request.value = response!
                peripheral.respond(to: request, withResult: .success)
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        var valueString = ""
        for request in requests {
            guard let value = request.value else { continue }
            valueString = String(data: value, encoding: .utf8)!
            peripheral.respond(to: request, withResult: .success)
        }
        writeCallback!(valueString, requests[0].central)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Got a notification subscription")
    }
    
    func notifySubscribedCentral(update: String, central: CBCentral) {
        let updateData = update.data(using: .utf8)!
        manager.updateValue(updateData, for: self.characteristics[2] as! CBMutableCharacteristic, onSubscribedCentrals: [central])
    }
}
