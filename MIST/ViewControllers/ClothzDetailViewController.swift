//
//  ClothzDetailViewController.swift
//  MIST
//
//  Created by Zach Babb on 2/1/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class ClothzDetailViewController: MistableViewController {
    
    let clothzDetailView = ClothzDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mistableView.addSubview(clothzDetailView)
        clothzDetailView.frame = view.frame
        /*clothzDetailView.translatesAutoresizingMaskIntoConstraints = false
        clothzDetailView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        clothzDetailView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        clothzDetailView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        clothzDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true*/
    }
}
