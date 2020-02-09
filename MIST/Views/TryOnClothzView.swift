//
//  TryOnClothzView.swift
//  MIST
//
//  Created by Zach Babb on 2/1/20.
//  Copyright © 2020 Planet Nine. All rights reserved.
//

import Foundation
import UIKit

protocol TryOnClothzViewDelegate {
    func homeButtonTapped()
    func checkoutTapped()
}

class TryOnClothzView: MistableUIView {
    
    let delegate: TryOnClothzViewDelegate
    let homeButton = MistableButton()
    let detailNameLabel = MistableLabel()
    let cartButton = CartButton()
    let lookingForLabel = MistableLabel()
    let keyPhrasesLabel = MistableLabel()
    let phraseOneButton = PhraseButton(phrase: "See fullscreen")
    let phraseTwoButton = PhraseButton(phrase: "Next color")
    let phraseThreeButton = PhraseButton(phrase: "Add to cart")
    let tryOnView = MistableButton()
    let showMoreButton = PhraseButton(phrase: "Show More")
    
    init(frame: CGRect, delegate: TryOnClothzViewDelegate) {
        self.delegate = delegate
        super.init(frame: frame)

        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init with coder unimplemented")
    }
    
    public func refreshCollection() {
        print("Should refresh collection")
    }
    
    private func addViews() {
        self.addSubview(homeButton)
        self.addSubview(detailNameLabel)
        self.addSubview(cartButton)
        self.addSubview(lookingForLabel)
        self.addSubview(keyPhrasesLabel)
        self.addSubview(phraseOneButton)
        self.addSubview(phraseTwoButton)
        self.addSubview(phraseThreeButton)
        self.addSubview(tryOnView)
        self.addSubview(showMoreButton)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        homeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 41).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        homeButton.setTitle("Browse", for: .normal)
        homeButton.setTitleColor(UIColor.black, for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonTapped(_:)), for: .touchUpInside)
        
        detailNameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        detailNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 74).isActive = true
        detailNameLabel.widthAnchor.constraint(equalToConstant: 106).isActive = true
        detailNameLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
        detailNameLabel.text = "Clothz"
        
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -13).isActive = true
        cartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 75).isActive = true
        cartButton.widthAnchor.constraint(equalToConstant: cartButton.frame.width).isActive = true
        cartButton.heightAnchor.constraint(equalToConstant: cartButton.frame.height).isActive = true
        
        lookingForLabel.translatesAutoresizingMaskIntoConstraints = false
        lookingForLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        lookingForLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 172).isActive = true
        lookingForLabel.widthAnchor.constraint(equalToConstant: 613).isActive = true
        lookingForLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
        lookingForLabel.text = "Like what you see?"
        lookingForLabel.textColor = UIColor.PlanetNineColors.secondary
        
        keyPhrasesLabel.translatesAutoresizingMaskIntoConstraints = false
        keyPhrasesLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        keyPhrasesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 229).isActive = true
        keyPhrasesLabel.widthAnchor.constraint(equalToConstant: 213).isActive = true
        keyPhrasesLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        keyPhrasesLabel.text = "Try key phrases, like"
        keyPhrasesLabel.textColor = UIColor.PlanetNineColors.primary
        
        let phraseButtonStackView = UIStackView()
        self.addSubview(phraseButtonStackView)
        phraseButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        phraseButtonStackView.leftAnchor.constraint(equalTo: keyPhrasesLabel.rightAnchor, constant: 12).isActive = true
        phraseButtonStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -13).isActive = true
        phraseButtonStackView.centerYAnchor.constraint(equalTo: keyPhrasesLabel.centerYAnchor).isActive = true
        phraseButtonStackView.heightAnchor.constraint(equalToConstant: phraseOneButton.frame.height).isActive = true
        phraseButtonStackView.spacing = 19
        phraseButtonStackView.axis = .horizontal
        phraseButtonStackView.addArrangedSubview(phraseOneButton)
        phraseButtonStackView.addArrangedSubview(phraseTwoButton)
        phraseButtonStackView.addArrangedSubview(phraseThreeButton)
        
        tryOnView.translatesAutoresizingMaskIntoConstraints = false
        tryOnView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        tryOnView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        tryOnView.topAnchor.constraint(equalTo: self.topAnchor, constant: 286).isActive = true
        tryOnView.heightAnchor.constraint(equalToConstant: 599).isActive = true
        tryOnView.backgroundColor = UIColor.PlanetNineColors.secondary
        tryOnView.addTarget(self, action: #selector(checkoutTapped(_:)), for: .touchUpInside)
        
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        showMoreButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        showMoreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13).isActive = true
        showMoreButton.widthAnchor.constraint(equalToConstant: 116).isActive = true
        showMoreButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        showMoreButton.layer.cornerRadius = 12
    }
    
    @objc private func homeButtonTapped(_ sender: UIButton) {
        print("Home button tapped")
        delegate.homeButtonTapped()
    }
    
    @objc private func checkoutTapped(_ sender: UIButton) {
        delegate.checkoutTapped()
    }
}
