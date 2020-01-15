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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addViews()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func addViews() {
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
    }
    
    @objc func weatherTapped(_ sender: UIResponder) {
        print(sender)
        let wdvc = WeatherDetailViewController()
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey:nil)
        self.navigationController?.pushViewController(wdvc, animated: false)
    }
}

