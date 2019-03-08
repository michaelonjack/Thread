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
    var deselectedTitle: String?
    var selectedIcon: UIImage?
    
    var isCollapsed: Bool = false
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
    
    init(deselectedTitle: String, selectedIcon: UIImage, selectAction: @escaping () -> Void, deselectAction: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        
        self.deselectedTitle = deselectedTitle
        self.selectedIcon = selectedIcon
        self.selectAction = selectAction
        self.deselectAction = deselectAction
        
        setupView()
    }
    
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
    }
    
    func setupView() {
        
        backgroundColor = .clear
        button.setTitle(deselectedTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        addSubview(button)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        buttonWidthAnchor = button.widthAnchor.constraint(equalTo: widthAnchor)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor),
            buttonWidthAnchor
        ])
    }
    
    @objc func buttonTapped() {
        if isCollapsed {
            buttonWidthAnchor.isActive = false
            buttonWidthAnchor = button.widthAnchor.constraint(equalTo: widthAnchor)
            buttonWidthAnchor.isActive = true
            
            button.setImage(nil, for: .normal)
            button.setTitle(deselectedTitle, for: .normal)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.button.backgroundColor = .clear
                self.layoutIfNeeded()
            })
            
            deselectAction()
        }
        
        else {
            buttonWidthAnchor.isActive = false
            buttonWidthAnchor = button.widthAnchor.constraint(equalTo: button.heightAnchor)
            buttonWidthAnchor.isActive = true
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.button.backgroundColor = .black
                self.layoutIfNeeded()
            }, completion: { (_) in
                self.button.setTitle(nil, for: .normal)
                self.button.setImage(self.selectedIcon, for: .normal)
            })
            
            selectAction()
        }
        
        isCollapsed = !isCollapsed
    }
    
    func collapse() {
        buttonWidthAnchor.isActive = false
        buttonWidthAnchor = button.widthAnchor.constraint(equalTo: button.heightAnchor)
        buttonWidthAnchor.isActive = true
        
        button.backgroundColor = .black
        button.setTitle(nil, for: .normal)
        button.setImage(self.selectedIcon, for: .normal)
        layoutIfNeeded()
        
        isCollapsed = true
    }
}
