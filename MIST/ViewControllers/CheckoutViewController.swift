//
//  CheckoutViewController.swift
//  MIST
//
//  Created by Zach Babb on 1/20/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class CheckoutViewController: UIViewController, BLEViewController {
    let checkoutButton = UIButton()
    let summaryLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        
    }
    
    override func accessibilityPerformEscape() -> Bool {
        self.navigationController?.popViewController(animated: true)
        return true
    }
    
    public func respondToValue(_ value: String) {
        summaryLabel.text = "HUZZAH! This purchase has completed!"
        checkoutButton.backgroundColor = .green
        checkoutButton.setTitle("Go Back", for: .normal)
    }
    
    public func log(_ statement: String) {
        print(statement)
    }
    
    private func addViews() {
        view.addSubview(summaryLabel)
        view.addSubview(checkoutButton)
        
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkoutButton.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        checkoutButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        checkoutButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        checkoutButton.backgroundColor = .blue
        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.accessibilityUserInputLabels = ["checkout"]
        checkoutButton.addTarget(self, action: #selector(checkout(_:)), for: .touchUpInside)
        
        summaryLabel.translatesAutoresizingMaskIntoConstraints = true
        summaryLabel.frame = CGRect(x: 32, y: 200, width: view.frame.width - 64, height: 200)
        summaryLabel.textAlignment = .center
        summaryLabel.text = "Here is where you can put together a summary of the purchase"
    }
    
    @objc private func checkout(_ sender: UIButton) {
        print("Checkout here")
        if sender.titleLabel?.text == "Go Back" {
            self.navigationController?.popViewController(animated: true)
        }
        BLEHandler.isCheckout = true
        BLEHandler.shared.viewController = self
        summaryLabel.text = "Verify this transaction on your watch or your phone to proceed."
        summaryLabel.backgroundColor = UIColor.PlanetNineColors.primary
    }
}
