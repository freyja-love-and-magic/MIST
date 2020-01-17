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
    
    let moveToShoppingButton = UIButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addViews()
        moveToShoppingButton.accessibilityUserInputLabels = ["shopping"]
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func addViews() {
        view.addSubview(weatherButton)
        view.addSubview(moveToShoppingButton)
        
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
        
        moveToShoppingButton.backgroundColor = UIColor.green
        moveToShoppingButton.frame = CGRect(x: 40, y: 400, width: 100, height: 100)
        moveToShoppingButton.addTarget(self, action: #selector(moveToShoppingTapped(_:)), for: .touchUpInside)
    }
    
    @objc func weatherTapped(_ sender: UIButton) {
        print(sender)
        let wdvc = WeatherDetailViewController()
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey:nil)
        self.navigationController?.pushViewController(wdvc, animated: false)
    }
    
    @objc func moveToShoppingTapped(_ sender: UIButton) {
        let shoppingVC = ShoppingViewController()
        self.navigationController?.pushViewController(shoppingVC, animated: false)
    }
}

