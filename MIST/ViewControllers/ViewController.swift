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
    
    var foreground: MistableUIView!
    var background: MistableUIView!
    
    var weatherWidget: WidgetView!
    var newsWidget: WidgetView!
    var calendarWidget: WidgetView!
    var clothzWidget: WidgetView!
    var planetNineWidget: WidgetView!
    
    var weatherDetail = WeatherDetailButton()
    var clothzDetail = ClothzDetailView()
        
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
        weatherDetail.savedScreenshot = weatherDetail.screenshot
        clothzDetail.savedScreenshot = clothzDetail.screenshot
        //foreground.savedScreenshot = foreground.screenshot
        //background.savedScreenshot = background.screenshot
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
        foreground = MistableUIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        foreground.backgroundColor = UIColor.white
        background = MistableUIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        view.addSubview(background)
        view.addSubview(foreground)
        
        background.backgroundColor = UIColor.green

        addWidgets()
        addDetails()

        foreground.addSubview(logLabel)
        logLabel.translatesAutoresizingMaskIntoConstraints = false
        logLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logLabel.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -300).isActive = true
        logLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        logLabel.numberOfLines = 0
        logLabel.lineBreakMode = .byWordWrapping
        log("Ready to start logging")
    }
    
    private func addWidgets() {
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
        
        calendarWidget = WidgetView(widgetName: "Calendar", widgetContent: UIView())
        foreground.addSubview(calendarWidget)
        
        calendarWidget.translatesAutoresizingMaskIntoConstraints = false
        calendarWidget.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        calendarWidget.topAnchor.constraint(equalTo: newsWidget.bottomAnchor, constant: 15).isActive = true
        calendarWidget.widthAnchor.constraint(equalToConstant: 511).isActive = true
        calendarWidget.heightAnchor.constraint(equalToConstant: 292).isActive = true
        
        clothzWidget = WidgetView(widgetName: "Clothz", widgetContent: UIView())
        foreground.addSubview(clothzWidget)
        
        clothzWidget.translatesAutoresizingMaskIntoConstraints = false
        clothzWidget.leftAnchor.constraint(equalTo: weatherWidget.rightAnchor, constant: 19).isActive = true
        clothzWidget.topAnchor.constraint(equalTo: view.topAnchor, constant: 151).isActive = true
        clothzWidget.widthAnchor.constraint(equalToConstant: 514).isActive = true
        clothzWidget.heightAnchor.constraint(equalToConstant: 599).isActive = true
        clothzWidget.addTarget(self, action: #selector(clothzTapped(_:)), for: .touchUpInside)
        
        planetNineWidget = WidgetView(widgetName: "Planet Nine", widgetContent: UIView())
        foreground.addSubview(planetNineWidget)
        
        planetNineWidget.translatesAutoresizingMaskIntoConstraints = false
        planetNineWidget.leftAnchor.constraint(equalTo: calendarWidget.rightAnchor, constant: 22).isActive = true
        planetNineWidget.topAnchor.constraint(equalTo: newsWidget.bottomAnchor, constant: 15).isActive = true
        planetNineWidget.widthAnchor.constraint(equalToConstant: 266).isActive = true
        planetNineWidget.heightAnchor.constraint(equalToConstant: 292).isActive = true
    }
    
    private func addDetails() {
        
        background.addSubview(weatherDetail)
        weatherDetail.translatesAutoresizingMaskIntoConstraints = false
        weatherDetail.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 18).isActive = true
        weatherDetail.topAnchor.constraint(equalTo: background.topAnchor, constant: 151).isActive = true
        weatherDetail.rightAnchor.constraint(equalTo: background.rightAnchor, constant: 18).isActive = true
        weatherDetail.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: 18).isActive = true
        
        background.addSubview(clothzDetail)
        clothzDetail.frame = background.frame
    }
    
    private func displayUser() {
        if let user = UserModel().getUser() {
            
        }
    }
    
    private func hideDetails() {
        clothzDetail.isHidden = true
        weatherDetail.isHidden = true
    }
    
     @objc private func weatherTapped(_ sender: UIButton) {
        print(sender)
        newsWidget.isHidden = false
        background.isHidden = true
        hideDetails()
        /*weatherWidget.mist()
        newsWidget.mist()
        calendarWidget.mist()
        clothzWidget.mist()
        planetNineWidget.mist {
            self.foreground.isHidden = true
            self.background.isHidden = false
            self.clothzDetail.mistIn()
        }*/
        weatherWidget.mist {
            self.foreground.isHidden = true
            self.background.isHidden = false
            self.weatherDetail.mistIn()
        }
        UIView.animate(withDuration: 1.0, animations: {
            self.foreground.alpha = 0.0
        })
    }
    
    @objc private func clothzTapped(_ sender: UIButton) {
        background.isHidden = true
        hideDetails()
        clothzWidget.mist {
            /*self.foreground.isHidden = true
            self.background.isHidden = false
            self.background.backgroundColor = UIColor.white
            self.clothzDetail.mistIn(size: GridSize(columns: 30, rows: 50), removeAfterCompletion: false) {
                self.clothzDetail.refreshCollection()
            }*/
            let clothzDetailVC = ClothzDetailViewController()
            self.navigationController?.pushViewController(clothzDetailVC, animated: false)
        }
        UIView.animate(withDuration: 1.0, animations: {
            self.foreground.alpha = 0.0
        })
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
