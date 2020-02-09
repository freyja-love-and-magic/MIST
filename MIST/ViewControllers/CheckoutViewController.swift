//
//  CheckoutViewController.swift
//  MIST
//
//  Created by Zach Babb on 2/1/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class CheckoutViewController: MistableViewController, CheckoutViewDelegate {

    var checkoutView: CheckoutView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutView = CheckoutView(frame: self.view.frame, delegate: self)
        mistableView.addSubview(checkoutView)
    }
    
    func homeButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func collectionViewItemTapped(item: UICollectionViewCell) {
        print("Item tapped with \(item)")
    }
}
