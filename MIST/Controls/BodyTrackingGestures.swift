//
//  BodyTrackingGestures.swift
//  MIST
//
//  Created by Zach Babb on 1/20/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import RealityKit
import ARKit

enum Hand {
    case rightHand
    case leftHand
}

class BodyTrackingGestures {
    
    var rightHandXPositions = [Float]()
    var leftHandXPositions = [Float]()
    let swipeThreshold = Float(0.05)
    let viewController: ShoppingViewController
    
    init(viewController: ShoppingViewController) {
        self.viewController = viewController
    }
    
    func updateHandTransform(transform: simd_float4x4, for hand: Hand) {
        let position = transform.columns.3
        let xPosition = position.x
        if hand == .rightHand {
            rightHandXPositions.append(xPosition)
        } else {
            leftHandXPositions.append(xPosition)
        }
    }
    
    func didSwipeRight() -> Bool {
        var lastPosition = rightHandXPositions[0]
        var toTheRight = 0
        for position in rightHandXPositions  {
            if position > lastPosition && fabsf(lastPosition - position) > swipeThreshold {
                toTheRight += 1
            }
            lastPosition = position
        }
        if toTheRight > 5 {
            return true
        }
        viewController.log("toTheRight \(toTheRight)")
        return false
    }
    
    func didSwipeLeft() -> Bool {
        var lastPosition = leftHandXPositions[0]
        var toTheLeft = 0
        for position in leftHandXPositions {
            if position < lastPosition && fabsf(lastPosition - position) > swipeThreshold {
                toTheLeft += 1
            }
            lastPosition = position
        }
        if toTheLeft > 5 {
            return true
        }
        viewController.log("toTheLeft \(toTheLeft)")
        return false
    }
    
    func resetGestures() {
        rightHandXPositions = [Float]()
        leftHandXPositions = [Float]()
    }
}
