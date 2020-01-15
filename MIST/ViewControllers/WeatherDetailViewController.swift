//
//  WeatherDetailViewController.swift
//  MIST
//
//  Created by Zach Babb on 1/14/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class WeatherDetailViewController: UIViewController {
    
    let weatherDetailButton = WeatherDetailButton()
    
    override func viewDidLoad() {
        addViews()
        self.view.backgroundColor = UIColor.white
    }
    
    func addViews() {
        view.addSubview(weatherDetailButton)
        
        weatherDetailButton.translatesAutoresizingMaskIntoConstraints = false
        weatherDetailButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        weatherDetailButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        weatherDetailButton.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        weatherDetailButton.heightAnchor.constraint(equalToConstant: 400).isActive = true
        weatherDetailButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
    }
    
    @objc func goBack(_ sender: UIResponder) {
        print(sender)
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey:nil)
        self.navigationController?.popViewController(animated: false)
    }
}
