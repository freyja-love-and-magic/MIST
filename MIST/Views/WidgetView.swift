//
//  WidgetView.swift
//  MIST
//
//  Created by Zach Babb on 1/31/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

class WidgetView: MistableButton {
    let widgetButton = UIButton()
    let widgetContent: UIView
    
    init(widgetName: String, widgetContent: UIView) {
        self.widgetContent = widgetContent
        super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        
        addViews()
        widgetButton.setTitle(widgetName, for: .normal)
        self.backgroundColor = UIColor.PlanetNineColors.secondary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init with coder is unimplemented")
    }
    
    func addViews() {
        self.addSubview(widgetButton)
        self.addSubview(widgetContent)
        
        widgetButton.translatesAutoresizingMaskIntoConstraints = false
        widgetButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 13).isActive = true
        widgetButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 21).isActive = true
        widgetButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        widgetButton.heightAnchor.constraint(equalToConstant: 37).isActive = true
        
        widgetButton.backgroundColor = UIColor.PlanetNineColors.primary
        widgetButton.setTitleColor(UIColor.PlanetNineColors.secondary, for: .normal)
        widgetButton.layer.cornerRadius = 18.5
        
        widgetContent.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        widgetContent.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        widgetContent.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        widgetContent.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
