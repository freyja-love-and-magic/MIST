//
//  PhraseButton.swift
//  MIST
//
//  Created by Zach Babb on 2/1/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class PhraseButton: MistableButton {
    
    init(phrase: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 180, height: 37))
        
        self.setTitle(phrase, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor.PlanetNineColors.primary
        self.layer.cornerRadius = 18.5
        self.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init with coder is unimplemented")
    }
    
}
