//
//  WeatherDetailButton.swift
//  MIST
//
//  Created by Zach Babb on 1/14/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class WeatherDetailButton: MistableButton {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.accessibilityUserInputLabels = ["weather", "the weather"]
        self.setTitle("Weather Details", for: .normal)
        self.setTitleColor(.green, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.backgroundColor = UIColor.gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("WeatherDetailButton init with coder unimplemented")
    }
}
