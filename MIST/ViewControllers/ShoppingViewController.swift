//
//  ShoppingViewController.swift
//  MIST
//
//  Created by Zach Babb on 1/15/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit
import RealityKit
import ARKit
import SceneKit

class ShoppingViewController: UIViewController, ARSessionDelegate {
    
    var arView: ARView?
    //var character: BodyTrackedEntity?
    let characterAnchor = AnchorEntity()
    var bodyTrackingGestures: BodyTrackingGestures!
    
    let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    let lastButton = UIButton(frame: CGRect(x: 0, y: 150, width: 150, height: 150))
    
    let addToCartButton = UIButton()
    let checkoutButton = UIButton()
    
    var sceneView: SCNView!
    let shirtNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 0.1, chamferRadius: 0))
    //let shirtNode = SCNNode(geometry: SCNSphere(radius: 0.5))
    
    let logLabel = UILabel()
    var logArray = [String]()
    
    let colors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.orange, UIColor.purple]
    var colorIndex = 0
    
    override func viewDidLoad() {
        //changeShirtNode(to: colors[colorIndex])
        if let image = UIImage(named: "shirt") {
            shirtNode.geometry?.firstMaterial?.diffuse.contents = image
        }

        self.view.backgroundColor = UIColor.black
        
        bodyTrackingGestures = BodyTrackingGestures(viewController: self)
        
        sceneView = SCNView()

        //setupAR()
        addViews()
        
        let scene = SCNScene()
        //shirtNode.scale = SCNVector3(0.2, 0.2, 0.2)
        shirtNode.position = SCNVector3(0, 0, -5)
        scene.rootNode.addChildNode(shirtNode)
        
        var cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView?.scene = scene
    }
    
    override func accessibilityPerformEscape() -> Bool {
        print("In perform escape")
        self.navigationController?.popViewController(animated: false)
        return true
    }
    
    public func log(_ statement: String?) {
        if let statement = statement {
            logArray.append(statement)
            while logArray.count > 4 {
                logArray.remove(at: 0)
            }
            var text = ""
            logArray.forEach { element in
                text += element
                text += "\n"
            }
            logLabel.text = text
            print(statement)
        } else {
            log("Trying to log nil")
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        log("Updated anchors here")
        for anchor in anchors {
            log("anchor looks like \(anchor)")
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            log("Got a body anchor")
            if let rightHandTransform = bodyAnchor.skeleton.localTransform(for: .rightHand) {
                bodyTrackingGestures.updateHandTransform(transform: rightHandTransform, for: .rightHand)
            }
            if let leftHandTransform = bodyAnchor.skeleton.localTransform(for: .leftHand) {
                 bodyTrackingGestures.updateHandTransform(transform: leftHandTransform, for: .leftHand)
            }
            
            //log("\(rightHandTransform)")
            log("Checking didSwipeRight")
            if bodyTrackingGestures.didSwipeRight() {
                log("didSwipeRight")
                changeShirtNode(to: .green)
                bodyTrackingGestures.resetGestures()
            }
            log("checking didSwipeLeft")
            if bodyTrackingGestures.didSwipeLeft() {
                log("didSwipeLeft")
                changeShirtNode(to: .orange)
                bodyTrackingGestures.resetGestures()
            }
        }
    }
    
    func changeShirtNode(to color: UIColor) {
        shirtNode.geometry?.firstMaterial?.diffuse.contents = color
    }
    
    private func addViews() {
        self.view.addSubview(sceneView)
        self.view.addSubview(nextButton)
        self.view.addSubview(lastButton)
        self.view.addSubview(addToCartButton)
        self.view.addSubview(logLabel)
        self.view.addSubview(checkoutButton)
        
        nextButton.accessibilityUserInputLabels = VoiceControl.addModifiersToUserInputLabels(labels: ["next"])
        nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        //nextButton.backgroundColor = .blue
        
        lastButton.accessibilityUserInputLabels = VoiceControl.addModifiersToUserInputLabels(labels: ["last"])
        lastButton.addTarget(self, action: #selector(last(_:)), for: .touchUpInside)
        
        print(lastButton.accessibilityUserInputLabels)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sceneView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sceneView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sceneView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        //sceneView.backgroundColor = .clear
        
        addToCartButton.accessibilityUserInputLabels = ["cart", "add to cart"]
        addToCartButton.backgroundColor = UIColor.green
        addToCartButton.frame = CGRect(x: 40, y: 400, width: 100, height: 100)
        addToCartButton.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
        
        logLabel.translatesAutoresizingMaskIntoConstraints = false
        logLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logLabel.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -300).isActive = true
        logLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        logLabel.numberOfLines = 0
        logLabel.lineBreakMode = .byWordWrapping
        log("Ready to start logging")
        
        checkoutButton.frame = CGRect(x: view.frame.width - 150, y: view.frame.height - 150, width: 150, height: 150)
        checkoutButton.accessibilityUserInputLabels = ["checkout"]
        checkoutButton.addTarget(self, action: #selector(checkout(_:)), for: .touchUpInside)
        checkoutButton.backgroundColor = .orange
    }
    
    /*private func setupAR() {
        guard ARBodyTrackingConfiguration.isSupported else {
            print("Cannot start AR")
            return
        }
        arView = ARView(frame: view.frame)
        if let arView = arView {
            arView.session.delegate = self
            
            // Run a body tracking configration.
            let configuration = ARBodyTrackingConfiguration()
            arView.session.run(configuration)
            
            arView.scene.addAnchor(characterAnchor)
            
        
            view.addSubview(arView)
            self.log("Added ARView")
        } else {
            self.log("Could not create ARView")
        }
    }*/
    
    @objc private func next(_ sender: UIButton) {
        print("Going next")
        colorIndex += 1
        if colorIndex >= colors.count {
            colorIndex = 0
        }
        changeShirtNode(to: colors[colorIndex])
    }
    
    @objc private func last(_ sender: UIButton) {
        print("Going last")
        colorIndex -= 1
        if colorIndex < 0 {
            colorIndex = colors.count - 1
        }
        changeShirtNode(to: colors[colorIndex])
    }
    
    @objc private func addToCart(_ sender: UIButton) {
        print("Add to cart here")
        let addedLabel = UILabel(frame: CGRect(x: 100, y: 500, width: 200, height: 60))
        addedLabel.text = "Added"
        view.addSubview(addedLabel)
        UIView.animate(withDuration: 1, animations: {
            addedLabel.alpha = 0
        }) { success in
            addedLabel.removeFromSuperview()
        }
    }
    
    @objc private func checkout(_ sender: UIButton) {
        print("Should checkout")
        let checkoutVC = CheckoutViewController()
        self.navigationController?.pushViewController(checkoutVC, animated: true)
    }
}
