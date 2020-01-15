//
//  WeatherView.swift
//  MIST
//
//  Created by Zach Babb on 1/14/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class WeatherButton: UIButton {
        
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.accessibilityUserInputLabels = ["weather", "the weather"]
        self.setTitle("WEATHER", for: .normal)
        self.setTitleColor(UIColor.blue, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("WeatherView init with coder unimplemented")
    }
}
