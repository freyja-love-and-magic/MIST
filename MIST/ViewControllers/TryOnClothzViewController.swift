//
//  TryOnClothzViewController.swift
//  MIST
//
//  Created by Zach Babb on 2/1/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class TryOnClothzViewController: MistableViewController, TryOnClothzViewDelegate {
    var tryOnClothzView: TryOnClothzView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryOnClothzView = TryOnClothzView(frame: self.view.frame, delegate: self)
        mistableView.addSubview(tryOnClothzView)
    }
    
    func homeButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
    
    
}
