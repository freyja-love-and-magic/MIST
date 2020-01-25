//
//  Utils.swift
//  Planet Nine
//
//  Created by Zach Babb on 11/14/18.
//  Copyright © 2018 Planet Nine. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

enum VectorDirections {
    case left
    case right
    case up
    case down
}

struct SimpleVector {
    let distance: CGFloat
    let direction: VectorDirections
}

class Utils {
    
    func saveEncodableToDefaults<T: Encodable>(_ object: T, key: String) {
        do {
            let jsonData = try JSONEncoder().encode(object)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let defaults = UserDefaults.standard
            defaults.set(jsonString, forKey: key)
        } catch {
            print("Error setting default")
            print(error)
        }
    }
    
    func encodableToJSONString<T: Encodable>(_ object: T) -> String {
        var jsonString = ""
        do {
            let jsonData = try JSONEncoder().encode(object)
            jsonString = String(data: jsonData, encoding: .utf8)!
        } catch {
            print("Error getting JSON string")
            print(error)
        }
        return jsonString
    }
    
    func encodableToJSONData<T: Encodable>(_ object: T) -> Data {
        var jsonData = Data()
        let encoder = JSONEncoder()
        do {
            jsonData = try encoder.encode(object)
        } catch {
            print(error)
        }
        return jsonData
    }
    
    func relationshipBetweenTwoPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> SimpleVector {
        
        let xDiff = firstPoint.x - secondPoint.x
        let yDiff = firstPoint.y - secondPoint.y
        let radix = pow(xDiff, CGFloat(2)) + pow(yDiff, CGFloat(2))
        let distance = CGFloat(sqrt(Double(radix)))
        var direction = VectorDirections.left
        if fabs(Double(xDiff)) > fabs(Double(yDiff)) {
            if firstPoint.x > secondPoint.x {
                direction = .left
            } else {
                direction = .right
            }
        } else {
            if firstPoint.y > secondPoint.y {
                direction = .down
            } else {
                direction = .up
            }
        }
        let simpleVector = SimpleVector(distance: distance, direction: direction)
        return simpleVector
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func urlEncoded() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidUsername() -> Bool {
        let usernameRegEx = "^(?=.{6,20}$)(?![-])(?!.*[-]{2})[a-zA-Z0-9-]+(?<![-])$"
        
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        let phoneNumberRegEx = "^[+]*[0-9\\s]{1,4}[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*$"
        
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        return phoneNumberTest.evaluate(with: self)
    }
    
    func isValidCode() -> Bool {
        let codeRegEx = "^[0-9]{6,6}$"
        
        let codeTest = NSPredicate(format: "SELF MATCHES %@", codeRegEx)
        return codeTest.evaluate(with: self)
    }
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    func getTime() -> String {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        print("TIME:")
        print(nowDouble)
        print("EMIT")
        return String(Int(nowDouble * 1000.0))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Ubuntu-Bold", size: 12)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Ubuntu-Medium", size: 12)]
        let normal = NSMutableAttributedString(string: text, attributes: attrs)
        append(normal)
        
        return self
    }
}

extension UIColor {
    struct PlanetNineColors {
        static var primary: UIColor { return UIColor(red: 93/255, green: 193/255, blue: 185/255, alpha: 1.0)}
        static var secondary: UIColor { return UIColor(red: 228/255, green: 210/255, blue: 197/255, alpha: 1.0)}
        static var textColor: UIColor { return UIColor(red: 40/255, green: 100/255, blue: 90/255, alpha: 1.0)}
        static var lightTextColor: UIColor { return UIColor(red: 155/255, green: 199/255, blue: 196/255, alpha: 1.0)}
        static var darkPrimary: UIColor { return UIColor(red: 40/255, green: 100/255, blue: 97/255, alpha: 1.0)}
        static var darkSecondary: UIColor { return UIColor(red: 137/255, green: 123/255, blue: 116/255, alpha: 1.0)}
        static var brightPrimary: UIColor { return UIColor(red: 63/255, green: 174/255, blue: 80/255, alpha: 1.0)}
        static var transulcentBrightPrimary: UIColor { return UIColor(red: 63/255, green: 174/255, blue: 80/255, alpha: 0.5)}
        static var translucentSagaColor: UIColor { return UIColor(red: 71/255, green: 183/255, blue: 90/255, alpha: 0.7)}
    }
}

protocol BLEViewController {
    func respondToValue(_ value: String)
    func log(_ statement: String) 
}


