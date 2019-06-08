//
//  CollapsibleButton.swift
//  Thread
//
//  Created by Michael Onjack on 2/24/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class CollapsibleButton: UIView {
    
    var selectAction: (() -> Void) = {}
    var deselectAction: (() -> Void) = {}
    var selectedTitle: String?
    var deselectedTitle: String?
    var collapsedIcon: UIImage? {
        didSet {
            collapsedImageView.image = collapsedIcon
        }
    }
    
    var isSelected: Bool = false
    var buttonWidthAnchor: NSLayoutConstraint!
    
    var button: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.borderWidth = 1
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .clear
        b.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 13.0)
        b.clipsToBounds = true
        
        return b
    }()
    
    var collapsedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .black
        iv.clipsToBounds = true
        iv.alpha = 0
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.layer.cornerRadius = button.frame.height / 2
        collapsedImageView.layer.cornerRadius = collapsedImageView.frame.height / 2
    }
    
    func setupView() {
        
        backgroundColor = .clear
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        addSubview(button)
        addSubview(collapsedImageView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        buttonWidthAnchor = button.widthAnchor.constraint(equalTo: widthAnchor)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor),
            buttonWidthAnchor,
            
            collapsedImageView.heightAnchor.constraint(equalTo: button.heightAnchor),
            collapsedImageView.widthAnchor.constraint(equalTo: collapsedImageView.heightAnchor),
            collapsedImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            collapsedImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        if isSelected {
            button.setTitle(deselectedTitle, for: .normal)
            button.setTitleColor(.black, for: .normal)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.button.backgroundColor = .clear
            })
            
            deselectAction()
        }
        
        else {
            buttonWidthAnchor.isActive = false
            buttonWidthAnchor = button.widthAnchor.constraint(equalTo: button.heightAnchor)
            buttonWidthAnchor.isActive = true
            
            self.button.setTitle(nil, for: .normal)
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.button.backgroundColor = .black
                self.layoutIfNeeded()
            }, completion: { (_) in
                
                self.collapsedImageView.alpha = 1
                
                self.buttonWidthAnchor.isActive = false
                self.buttonWidthAnchor = self.button.widthAnchor.constraint(equalTo: self.widthAnchor)
                self.buttonWidthAnchor.isActive = true
                
                UIView.animate(withDuration: 0.7, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.collapsedImageView.alpha = 0
                    self.layoutIfNeeded()
                }, completion: { (_) in
                    self.button.setTitle(self.selectedTitle, for: .normal)
                    self.button.setTitleColor(.white, for: .normal)
                })
            })
            
            selectAction()
        }
        
        isSelected = !isSelected
    }
    
    func select() {
        button.backgroundColor = .black
        button.setTitle(selectedTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        isSelected = true
    }
}
