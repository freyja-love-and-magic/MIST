//
//  MistTransition.swift
//  MIST
//
//  Created by Zach Babb on 1/25/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//  Modified from https://github.com/artrmz/VariousViewsEffects

import UIKit

struct MistPiece {
    let position: CGPoint
    let image: UIImage
}

public extension UIView {
    
    /// Animates the view and hides it afterwards. Does nothing if view has no superview.
    ///
    /// - Parameters:
    /// - Parameter size: Describes the number of columns and rows on which the view is broken (default: 20x40)
    /// - Parameter removeAfterCompletion: Removes view from superview after animation completes
    /// - Parameter completion: Animation completion block
    func mist(size: GridSize = GridSize(columns: 20, rows: 40), removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        guard let screenshot = self.screenshot, !isHidden else {
            return
        }

        let pieces = calculatePieces(for: screenshot, size: size)
        mistAnimation(with: pieces, removeAfterCompletion: removeAfterCompletion, completion: completion)
    }


    private func mistAnimation(with pieces: [MistPiece], removeAfterCompletion: Bool, completion: (() -> Void)?) {
        let animationView = UIView()
        animationView.clipsToBounds = true
        animationView.frame = self.frame
        guard let superview = self.superview else {
            return
        }

        self.isHidden = true
        superview.addSubview(animationView)

        let pieceLayers = showJointPieces(pieces, animationView: animationView)
        animateMist(with: pieceLayers, animationView: animationView, removeAfterCompletion: removeAfterCompletion, completion: completion)
    }

    private func animateMist(with pieces: [CALayer], animationView: UIView, removeAfterCompletion: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            animationView.removeFromSuperview()
            if removeAfterCompletion {
                self.removeFromSuperview()
            }

            completion?()
        }
        pieces.forEach { pieceLayer in
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
            animation.beginTime = CACurrentMediaTime()
            animation.duration = (0.5...1.0).random()
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isCumulative = true
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            var trans = pieceLayer.transform
            trans = CATransform3DTranslate(trans,
                                           (-self.frame.size.width...self.frame.size.width).random() * 0.3,
                                           (-self.frame.size.height...self.frame.size.height).random() * 0.3,
                                           0)
            trans = CATransform3DRotate(trans, (-1.0...1.0).random() * CGFloat.pi * 0.25, 0, 0, 1)
            let scale: CGFloat = (0.05...0.65).random()
            trans = CATransform3DScale(trans, scale, scale, 1)
            animation.toValue = NSValue(caTransform3D: trans)
            pieceLayer.add(animation, forKey: nil)

            let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            opacityAnimation.beginTime = CACurrentMediaTime() + (0.01...0.3).random()
            opacityAnimation.duration = (0.3...0.7).random()
            opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
            opacityAnimation.isCumulative = true
            opacityAnimation.isRemovedOnCompletion = false
            opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            opacityAnimation.toValue = 0
            pieceLayer.add(opacityAnimation, forKey: nil)

        }
        CATransaction.commit()
    }

    private func showJointPieces(_ pieces: [MistPiece], animationView: UIView) -> [CALayer] {
        var allPieceLayers = [CALayer]()
        for index in 0..<pieces.count {
            let piece = pieces[index]
            let pieceLayer = CALayer()
            pieceLayer.contents = piece.image.cgImage
            pieceLayer.frame = CGRect(x: piece.position.x, y: piece.position.y, width: piece.image.size.width, height: piece.image.size.height)
            animationView.layer.addSublayer(pieceLayer)
            allPieceLayers.append(pieceLayer)
        }

        return allPieceLayers
    }

    private func calculatePieces(for image: UIImage, size: GridSize) -> [MistPiece] {
        var pieces = [MistPiece]()
        let columns = size.columns
        let rows = size.rows

        let singlePieceSize = CGSize(width: image.size.width / CGFloat(columns), height: image.size.height / CGFloat(rows))

        for row in 0..<rows {
            for column in 0..<columns {
                let position = CGPoint(x: CGFloat(column) * singlePieceSize.width, y: CGFloat(row) * singlePieceSize.height)

                let cropRect = CGRect(x: position.x * image.scale,
                                      y: position.y * image.scale,
                                      width: singlePieceSize.width * image.scale,
                                      height: singlePieceSize.height * image.scale)
                guard
                    let cgImage = image.cgImage,
                    let pieceCgImage = cgImage.cropping(to: cropRect)
                else {
                    continue
                }

                let pieceImage = UIImage.init(cgImage: pieceCgImage, scale: image.scale, orientation: image.imageOrientation)
                let piece = MistPiece(position: position, image: pieceImage)
                pieces.append(piece)
            }
        }

        return pieces
    }
}

extension UIView {
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: bounds, afterScreenUpdates: true)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        UIGraphicsEndImageContext()

        return image
    }
}

extension ClosedRange where Bound: FloatingPoint {
    func random() -> Bound {
        let max = UInt32.max
        return
            Bound(arc4random_uniform(max)) /
                Bound(max) *
                (upperBound - lowerBound) +
        lowerBound
    }
}
