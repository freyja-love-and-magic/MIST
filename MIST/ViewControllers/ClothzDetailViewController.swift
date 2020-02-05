//
//  ClothzDetailViewController.swift
//  MIST
//
//  Created by Zach Babb on 2/1/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class ClothzDetailViewController: MistableViewController, ClothzDetailViewDelegate {

    var clothzDetailView: ClothzDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clothzDetailView = ClothzDetailView(frame: self.view.frame, delegate: self)
        mistableView.addSubview(clothzDetailView)
    }
    
    func homeButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func collectionViewItemTapped(item: UICollectionViewCell) {
        print("Item tapped with \(item)")
        mistableView.mist {
            let tryOnClothzVC = TryOnClothzViewController()
            self.navigationController?.pushViewController(tryOnClothzVC, animated: false)
        }
    }
}
