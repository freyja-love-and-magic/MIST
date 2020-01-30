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
    
    let userLabel = UILabel()
    
    let weatherButton = WeatherButton()
    var weatherButtonCenterXConstraint: NSLayoutConstraint!
    var weatherButtonCenterYConstraint: NSLayoutConstraint!
    
    let moveToShoppingButton = UIButton()
    
    let logLabel = UILabel()
    var logArray = [String]()
    
    let network = Network()
    
    var emitter: SKEmitterNode?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addViews()
        moveToShoppingButton.accessibilityUserInputLabels = VoiceControl.addModifiersToUserInputLabels(labels: ["shopping"])
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        emitter = SKEmitterNode(fileNamed: "MagicParticle.sks")
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
        view.addSubview(userLabel)
        view.addSubview(weatherButton)
        view.addSubview(moveToShoppingButton)
        view.addSubview(logLabel)
        
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -150).isActive = true
        userLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        userLabel.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 185).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        userLabel.numberOfLines = 0
        userLabel.lineBreakMode = .byWordWrapping
        
        weatherButton.translatesAutoresizingMaskIntoConstraints = false
        //weatherButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        weatherButtonCenterXConstraint = weatherButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 150)
            weatherButtonCenterXConstraint.isActive = true
        weatherButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        //weatherButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        weatherButtonCenterYConstraint = weatherButton.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: 185)
            weatherButtonCenterYConstraint.isActive = true
        weatherButton.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        weatherButton.addTarget(self, action: #selector(weatherTapped(_:)), for: .touchUpInside)
        weatherButton.backgroundColor = UIColor.green
        
        moveToShoppingButton.backgroundColor = UIColor.green
        moveToShoppingButton.frame = CGRect(x: 40, y: 400, width: 100, height: 100)
        moveToShoppingButton.addTarget(self, action: #selector(moveToShoppingTapped(_:)), for: .touchUpInside)
        moveToShoppingButton.accessibilityUserInputLabels = VoiceControl.addModifiersToUserInputLabels(labels: ["shopping"])
        
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
            userLabel.text = "Hello \(user.name)\nYou have \(user.nineum.count) Nineum."
            userLabel.backgroundColor = .cyan
        }
    }
    
     @objc private func weatherTapped(_ sender: UIButton) {
        print(sender)
        /*let wdvc = WeatherDetailViewController()
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey:nil)
        self.navigationController?.pushViewController(wdvc, animated: false)*/
        /*let scene = SKScene(size: CGSize(width: sender.frame.width, height: sender.frame.height))
        
        if let emitter = emitter {
            emitter.particleLifetime = 0.2
            emitter.numParticlesToEmit = 400
            scene.addChild(emitter)
            let skView = SKView(frame: sender.frame)
            view.addSubview(skView)
            skView.presentScene(scene)
        }*/
        
        sender.mist()
        
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
