//
//  VoiceControl.swift
//  MIST
//
//  Created by Zach Babb on 1/20/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation

class VoiceControl {
    
    static let modifiers = ["show me ", "go to "]
    
    static func addModifiersToUserInputLabels(labels: Array<String>) -> Array<String> {
        var newLabels = labels
        labels.forEach { label in
                VoiceControl.modifiers.forEach { modifier in
                newLabels.append(modifier + label)
            }
        }
        return newLabels
    }
}
