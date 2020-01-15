//
//  ViewController.swift
//  MIST
//
//  Created by Zach Babb on 1/14/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let weatherButton = WeatherButton()
    var weatherButtonCenterXConstraint: NSLayoutConstraint!
    var weatherButtonCenterYConstraint: NSLayoutConstraint!
    let weatherDetailButton = WeatherDetailButton()
    
    let centeredView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addViews()
    }

    func addViews() {
        view.addSubview(centeredView)
        view.addSubview(weatherButton)
        
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
        
        centeredView.translatesAutoresizingMaskIntoConstraints = false
        centeredView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        centeredView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        centeredView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        centeredView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    @objc func weatherTapped(_ sender: UIResponder) {
        print(sender)
        weatherDetailButton.frame = centeredView.frame
        /*UIView.animate(withDuration: 0.3, animations: {
            self.weatherButtonCenterXConstraint.constant = 0
            self.weatherButtonCenterYConstraint.constant = self.view.frame.height / 2
            self.view.layoutIfNeeded()
        }) { success in
            print("first: \(success)")
            UIView.transition(from: self.weatherButton, to: self.weatherDetailButton, duration: 0.3, options: [.curveEaseInOut, .transitionCrossDissolve]) { success in
                print(success)
            }
        }*/
        UIView.transition(from: self.weatherButton, to: self.weatherDetailButton, duration: 0.3, options: [.curveEaseInOut, .transitionCrossDissolve]) { success in
            print(success)
        }
    }
}

