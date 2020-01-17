//
//  ShoppingViewController.swift
//  MIST
//
//  Created by Zach Babb on 1/15/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class ShoppingViewController: UIViewController {
    
    let addToCartButton = UIButton()
    var sceneView: SCNView!
    //let shirtNode = SCNNode(geometry: SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.2))
    let shirtNode = SCNNode(geometry: SCNSphere(radius: 0.5))
    
    override func viewDidLoad() {
        shirtNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red

        self.view.backgroundColor = UIColor.white
        
        sceneView = SCNView()

        addViews()
        
        let scene = SCNScene()
        //shirtNode.scale = SCNVector3(0.2, 0.2, 0.2)
        shirtNode.position = SCNVector3(0, 0, -10)
        scene.rootNode.addChildNode(shirtNode)
        
        var cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView?.scene = scene
    }
    
    func addViews() {
        self.view.addSubview(sceneView)
        self.view.addSubview(addToCartButton)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sceneView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        sceneView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sceneView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        addToCartButton.accessibilityUserInputLabels = ["cart"]
        addToCartButton.backgroundColor = UIColor.green
        addToCartButton.frame = CGRect(x: 40, y: 400, width: 100, height: 100)
        addToCartButton.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
    }
    
    @objc func addToCart(_ sender: UIButton) {
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
}
