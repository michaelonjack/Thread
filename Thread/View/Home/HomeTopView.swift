//
//  HomeUserDetailsView.swift
//  Thread
//
//  Created by Michael Onjack on 3/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeTopView: UIView {
    
    var profilePictureButton: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.clipsToBounds = true
        b.contentMode = .scaleAspectFill
        b.layer.borderColor = UIColor.white.cgColor
        b.layer.borderWidth = 2.0
        
        return b
    }()
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        l.textColor = .white
        l.backgroundColor = .clear
        l.textAlignment = .left
        
        return l
    }()
    
    var locationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium)
        l.textColor = .white
        l.backgroundColor = .clear
        l.textAlignment = .left
        
        return l
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
        
        layer.cornerRadius = frame.height / 5.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        profilePictureButton.layer.cornerRadius = profilePictureButton.frame.height / 2
    }
    
    fileprivate func setupView() {
        backgroundColor = .black
        clipsToBounds = true
        
        addSubview(profilePictureButton)
        addSubview(nameLabel)
        addSubview(locationLabel)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            profilePictureButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            profilePictureButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profilePictureButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            profilePictureButton.widthAnchor.constraint(equalTo: profilePictureButton.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profilePictureButton.topAnchor),
            nameLabel.heightAnchor.constraint(equalTo: profilePictureButton.heightAnchor, multiplier: 0.5),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            nameLabel.leadingAnchor.constraint(equalTo: profilePictureButton.trailingAnchor, constant: 16),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: profilePictureButton.bottomAnchor)
        ])
    }
}
