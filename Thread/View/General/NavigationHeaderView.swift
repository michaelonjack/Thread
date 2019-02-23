//
//  NavigationHeaderView.swift
//  Thread
//
//  Created by Michael Onjack on 2/23/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class NavigationHeaderView: UIView {
    
    var previousViewLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
        l.textColor = .lightGray
        
        return l
    }()
    
    var currentViewLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.font = UIFont(name: "AvenirNext-Medium", size: 25.0)
        l.textColor = .black
        
        return l
    }()
    
    var backButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "BackArrow"), for: .normal)
        
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        addSubview(previousViewLabel)
        addSubview(currentViewLabel)
        addSubview(backButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: previousViewLabel.centerYAnchor),
            backButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            previousViewLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
            previousViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            previousViewLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            currentViewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currentViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            currentViewLabel.topAnchor.constraint(equalTo: previousViewLabel.bottomAnchor)
        ])
    }
}
