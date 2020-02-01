//
//  ViewController.swift
//  MIST
//
//  Created by Zach Babb on 1/14/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, BLEViewController {
    
    var foreground: UIView!
    var background: UIView!
    
    var weatherWidget: WidgetView!
    var newsWidget: WidgetView!
    
    var clothzDetail = MistableButton()
        
    let logLabel = UILabel()
    var logArray = [String]()
    
    let network = Network()
    
    var emitter: SKEmitterNode?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addViews()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        emitter = SKEmitterNode(fileNamed: "MagicParticle.sks")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        weatherWidget.savedScreenshot = weatherWidget.screenshot
        newsWidget.savedScreenshot = newsWidget.screenshot
        clothzDetail.savedScreenshot = clothzDetail.screenshot
    }
    
    public func respondToValue(_ value: String) {
        if let magicGetUserGateway = GatewayModel.magicGetUserGateway(from: value) {
            network.getUserById(userId: magicGetUserGateway.userId, gatewayName: magicGetUserGateway.gatewayName, timestamp: magicGetUserGateway.timestamp, signature: magicGetUserGateway.signature) { error, data in
                if let error = error {
                    print("Error getting user \(error)")
                    return
                }
                if let data = data {
                    UserModel().saveUserFromJSON(user: String(data: data, encoding: .utf8) ?? "")
                    self.displayUser()
                } else {
                    print("Got no error or data")
                }
            }
        }
    }
    
    public func log(_ statement: String) {
        logArray.append(statement)
        while logArray.count > 4 {
            logArray.remove(at: 0)
        }
        var text = ""
        logArray.forEach { element in
            text += element
            text += "\n"
        }
        logLabel.text = text
        print(statement)
    }

    private func addViews() {
        foreground = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        foreground.backgroundColor = UIColor.white
        background = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        view.addSubview(background)
        view.addSubview(foreground)
        
        foreground.addSubview(logLabel)
        
        weatherWidget = WidgetView(widgetName: "Weather", widgetContent: UIView())
        foreground.addSubview(weatherWidget)
        
        weatherWidget.translatesAutoresizingMaskIntoConstraints = false
        weatherWidget.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        weatherWidget.topAnchor.constraint(equalTo: view.topAnchor, constant: 151).isActive = true
        weatherWidget.widthAnchor.constraint(equalToConstant: 266).isActive = true
        weatherWidget.heightAnchor.constraint(equalToConstant: 292).isActive = true
        
        weatherWidget.addTarget(self, action: #selector(weatherTapped(_:)), for: .touchUpInside)
        
        newsWidget = WidgetView(widgetName: "News", widgetContent: UIView())
        foreground.addSubview(newsWidget)
        
        newsWidget.translatesAutoresizingMaskIntoConstraints = false
        newsWidget.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        newsWidget.topAnchor.constraint(equalTo: weatherWidget.bottomAnchor, constant: 15).isActive = true
        newsWidget.widthAnchor.constraint(equalToConstant: 266).isActive = true
        newsWidget.heightAnchor.constraint(equalToConstant: 292).isActive = true
        
        background.addSubview(clothzDetail)
        clothzDetail.backgroundColor = UIColor.PlanetNineColors.primary
        clothzDetail.setTitle("HEYOOOO", for: .normal)
        clothzDetail.frame = CGRect(x: 200, y: 200, width: 200, height: 100)
        
        logLabel.translatesAutoresizingMaskIntoConstraints = false
        logLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logLabel.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -300).isActive = true
        logLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        logLabel.numberOfLines = 0
        logLabel.lineBreakMode = .byWordWrapping
        log("Ready to start logging")
    }
    
    private func displayUser() {
        if let user = UserModel().getUser() {
            
        }
    }
    
     @objc private func weatherTapped(_ sender: UIButton) {
        print(sender)
        newsWidget.isHidden = false
        background.isHidden = true
        clothzDetail.isHidden = true
        sender.mist()
        newsWidget.mist {
            self.foreground.isHidden = true
            self.background.isHidden = false
            self.clothzDetail.mistIn()
        }
    }
    
    @objc private func moveToShoppingTapped(_ sender: UIButton) {
        let shoppingVC = ShoppingViewController()
        self.navigationController?.pushViewController(shoppingVC, animated: false)
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
