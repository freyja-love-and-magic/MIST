//
//  MistableButton.swift
//  MIST
//
//  Created by Zach Babb on 1/31/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class MistableButton: UIButton, MistableView {
    var savedScreenshot: UIImage?
}

class MistableUIView: UIView, MistableView {
    var savedScreenshot: UIImage?
}

class MistableLabel: UILabel, MistableView {
    var savedScreenshot: UIImage?
}
