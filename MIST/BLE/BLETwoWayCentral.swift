//
//  BLETwoWayCentral.swift
//  Planet Nine
//
//  Created by Zach Babb on 12/13/18.
//  Copyright © 2018 Planet Nine. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BLETwoWayCentral: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager: CBCentralManager?
    var peripherals: [CBPeripheral]?
    var readCharacteristic: CBCharacteristic?
    var writeCharacteristic: CBCharacteristic?
    var notifyCharacteristic: CBCharacteristic?
    var readCallback: ((String) -> Void)?
    var writeCallback: (() -> Void)?
    var notifyCallback: ((String) -> Void)?
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
        peripherals = [CBPeripheral]()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("off")
        case .poweredOn:
            print("Powered On")
            central.scanForPeripherals(withServices: [bleServices().twoWay], options: nil)
            //central.scanForPeripherals(withServices: nil, options: nil)

        case .unauthorized:
            print("unauthorized")
        case .resetting:
            print("resetting")
        case .unknown:
            print("unknown")
        case .unsupported:
            print("unsupported")
        default:
            print("Got to default somehow")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral")
        print("\n\n")
        print(peripheral)
        print("\n\n")
        peripherals?.append(peripheral)
        manager?.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral")
        peripheral.delegate = self
        peripheral.discoverServices([bleServices().twoWay])
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.checkForConnectedPeripherals()
        }
    }
    
    func checkForConnectedPeripherals() {
        guard let peripherals = manager?.retrieveConnectedPeripherals(withServices: [bleServices().twoWay]) else {
            return
        }
        if peripherals.count == 0 {
            return
        }
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.checkForConnectedPeripherals()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("We got them services")
        peripheral.discoverCharacteristics([bleCharacteristics().read, bleCharacteristics().write, bleCharacteristics().notify], for: peripheral.services![0])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            print(characteristic.uuid)
            switch characteristic.uuid {
            case bleCharacteristics().read:
                print("Read it!")
                readCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
                break
            case bleCharacteristics().write:
                print("Write to it!")
                writeCharacteristic = characteristic
                //peripheral.writeValue("Heyooo".data(using: .utf8)!, for: characteristic, type: .withResponse)
                break
            case bleCharacteristics().notify:
                print("Subscribe to it!")
                notifyCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                break
            default:
                print("Got to the characteristics default somehow")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("You've got an updated value there buddy")
        print(String(data: characteristic.value!, encoding: .utf8))
        print(characteristic.uuid)
        print(readCharacteristic?.uuid)
        guard let value = characteristic.value else { return }
        guard let valueString = String(data: value, encoding: .utf8) else { return }
        if characteristic.uuid == readCharacteristic?.uuid {
            readCallback?(valueString)
        } else if characteristic.uuid == notifyCharacteristic?.uuid {
            notifyCallback?(valueString)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Apparently you wrote the value")
        writeCallback?()
    }
    
    func writeValue(value: String) {
        if let peripheral = peripherals?.first,
           let writeCharacteristic = writeCharacteristic {
            peripheral.writeValue(value.data(using: .utf8)!, for: writeCharacteristic, type: .withResponse)
        }
    }
    
}
