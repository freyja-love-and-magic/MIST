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
    
    func mistIn(size: GridSize = GridSize(columns: 20, rows: 40), removeAfterCompletion: Bool = false, completion: (() -> Void)? = nil) {
        if let mistableView = self as? MistableView,
           let screenshot = mistableView.savedScreenshot {
            let pieces = calculatePieces(for: screenshot, size: size)
            mistInAnimation(with: pieces, removeAfterCompletion: removeAfterCompletion) {
                self.isHidden = false
                completion?()
            }
        }
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
            print("removing animationView from superView")
            animationView.removeFromSuperview()
            if removeAfterCompletion {
                print("removeAfterCompletion")
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
            let scale: CGFloat = (0.05...0.35).random()
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
            
            let maskAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
            maskAnimation.beginTime = CACurrentMediaTime()
            maskAnimation.duration = (0.2...0.6).random()
            maskAnimation.fillMode = CAMediaTimingFillMode.forwards
            maskAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            maskAnimation.toValue = pieceLayer.frame.height * 2
            maskAnimation.isCumulative = true
            maskAnimation.isRemovedOnCompletion = false
            pieceLayer.masksToBounds = true
            pieceLayer.add(maskAnimation, forKey: nil)
            
            /*let colorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
            colorAnimation.beginTime = CACurrentMediaTime()
            colorAnimation.duration = (0.2...1.0).random()
            //colorAnimation.fillMode = CAMediaTimingFillMode.forwards
            colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            colorAnimation.toValue = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
            //colorAnimation.fromValue = pieceLayer.backgroundColor
            //colorAnimation.toValue = UIColor.blue.cgColor
            colorAnimation.isCumulative = true
            colorAnimation.isRemovedOnCompletion = false
            pieceLayer.add(colorAnimation, forKey: nil)*/

        }
        CATransaction.commit()
    }
    
    private func mistInAnimation(with pieces: [MistPiece], removeAfterCompletion: Bool, completion: (() -> Void)?) {
        let animationView = UIView()
        animationView.clipsToBounds = true
        animationView.frame = self.frame
        print("animationView.frame \(animationView.frame)")
        guard let superview = self.superview else {
            return
        }

        self.isHidden = true
        superview.addSubview(animationView)

        let pieceLayers = showJointPiecesIn(pieces, animationView: animationView)
        animateMistIn(with: pieceLayers, animationView: animationView, removeAfterCompletion: removeAfterCompletion, completion: completion)
    }

    private func animateMistIn(with pieces: [CALayer], animationView: UIView, removeAfterCompletion: Bool, completion: (() -> Void)?) {
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
            let endTransform = pieceLayer.transform
            trans = CATransform3DTranslate(trans,
                                           (-self.frame.size.width...self.frame.size.width).random() * 0.3,
                                           (-self.frame.size.height...self.frame.size.height).random() * 0.3,
                                           0)
            trans = CATransform3DRotate(trans, (-1.0...1.0).random() * CGFloat.pi * 0.25, 0, 0, 1)
            let scale: CGFloat = (0.05...0.35).random()
            trans = CATransform3DScale(trans, scale, scale, 1)
            animation.fromValue = NSValue(caTransform3D: trans)
            animation.toValue = endTransform
            pieceLayer.add(animation, forKey: nil)

            let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            opacityAnimation.beginTime = CACurrentMediaTime() + (0.01...0.3).random()
            opacityAnimation.duration = (0.1...0.8).random()
            opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
            opacityAnimation.isCumulative = true
            opacityAnimation.isRemovedOnCompletion = false
            opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            opacityAnimation.fromValue = 0
            opacityAnimation.toValue = 1
            pieceLayer.add(opacityAnimation, forKey: nil)
            
            let maskAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
            maskAnimation.beginTime = CACurrentMediaTime()
            maskAnimation.duration = (0.5...1.0).random()
            maskAnimation.fillMode = CAMediaTimingFillMode.forwards
            maskAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            maskAnimation.fromValue = pieceLayer.frame.height * 2
            maskAnimation.toValue = 0
            maskAnimation.isCumulative = true
            maskAnimation.isRemovedOnCompletion = false
            pieceLayer.masksToBounds = true
            pieceLayer.add(maskAnimation, forKey: nil)
            
            /*let colorAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
            colorAnimation.beginTime = CACurrentMediaTime()
            colorAnimation.duration = (0.2...1.0).random()
            //colorAnimation.fillMode = CAMediaTimingFillMode.forwards
            colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            colorAnimation.toValue = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
            //colorAnimation.fromValue = pieceLayer.backgroundColor
            //colorAnimation.toValue = UIColor.blue.cgColor
            colorAnimation.isCumulative = true
            colorAnimation.isRemovedOnCompletion = false
            pieceLayer.add(colorAnimation, forKey: nil)*/

        }
        CATransaction.commit()
        animationView.isHidden = false

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
    
    private func showJointPiecesIn(_ pieces: [MistPiece], animationView: UIView) -> [CALayer] {
        animationView.isHidden = true
        var allPieceLayers = [CALayer]()
        for index in 0..<pieces.count {
            let piece = pieces[index]
            let pieceLayer = CALayer()
            pieceLayer.contents = piece.image.cgImage
            pieceLayer.frame = CGRect(x: piece.position.x, y: piece.position.y, width: piece.image.size.width, height: piece.image.size.height)
            pieceLayer.opacity = 0
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

protocol MistableView {
    var savedScreenshot: UIImage? { get set }
}
