//
//  CartButton.swift
//  MIST
//
//  Created by Zach Babb on 2/1/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class CartButton: MistableButton {
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 180, height: 37))
        
        self.layer.cornerRadius = 18.5
        self.backgroundColor = UIColor.PlanetNineColors.brightPrimary
        self.setTitleColor(UIColor.white, for: .normal)
        setCartAmount(0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init with coder is unimplemented")
    }
    
    func setCartAmount(_ amount: Int) {
        self.setTitle("Cart (\(amount))", for: .normal)
    }
}
