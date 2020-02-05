//
//  MistableViewController.swift
//  MIST
//
//  Created by Zach Babb on 2/1/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class MistableViewController: UIViewController {
    var mistableView: MistableUIView!
    var coverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mistableView = MistableUIView(frame: view.frame)
        coverView = UIView(frame: view.frame)
        
        view.addSubview(mistableView)
        view.addSubview(coverView)
        
        //mistableView.alpha = 0
        view.backgroundColor = UIColor.white
        mistableView.backgroundColor = UIColor.white
        coverView.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*coverView.isHidden = true
        //UIView.animate(withDuration: 1.0, animations: {
        //    self.mistableView.alpha = 1.0
        //})
        print("View didAppear")
        mistableView.isHidden = false
        mistableView.savedScreenshot = mistableView.screenshot
        print("saved screenshot: \(mistableView.savedScreenshot)")
        //mistableView.isHidden = true
        coverView.isHidden = true
        mistableView.mistIn(size: GridSize(columns: 40, rows: 60), removeAfterCompletion: false) {
            self.mistableView.isHidden = false
            //self.mistableView.savedScreenshot = self.mistableView.screenshot
            let imageView = UIImageView(image: self.mistableView.savedScreenshot)
            self.mistableView.addSubview(imageView)
            imageView.frame = CGRect(x: 50, y: 50, width: 500, height: 500)
            imageView.backgroundColor = UIColor.blue
        }*/
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { _ in
            self.startMist()
        }
        
    }
    
    func startMist() {
        mistableView.savedScreenshot = mistableView.savedScreenshot == nil ? mistableView.screenshot : mistableView.savedScreenshot
        print("saved screenshot: \(mistableView.savedScreenshot)")
        //mistableView.isHidden = true
        coverView.isHidden = true
        mistableView.mistIn(size: GridSize(columns: 40, rows: 60), removeAfterCompletion: false) {
            self.mistableView.isHidden = false
        }
    }
    
}

