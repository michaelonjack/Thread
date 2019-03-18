//
//  UserClothingItemTableViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 3/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserClothingItemTableViewCell: ClothingItemTableViewCell {
    
    var userProfilePictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    var userNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .black
        l.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        
        return l
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userProfilePictureImageView.layer.cornerRadius = userProfilePictureImageView.frame.height / 2
    }
    
    override func setupView() {
        
        addSubview(userProfilePictureImageView)
        addSubview(userNameLabel)
        
        super.setupView()
    }
    
    override func setupLayout() {
        
        // Lower the priority of the top constraint to prevent the logger from whining during layout
        let clothingItemImageViewTopConstraint = clothingItemImageView.topAnchor.constraint(equalTo: userProfilePictureImageView.bottomAnchor, constant: 16)
        clothingItemImageViewTopConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            userProfilePictureImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userProfilePictureImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userProfilePictureImageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.1),
            userProfilePictureImageView.heightAnchor.constraint(equalTo: userProfilePictureImageView.widthAnchor),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userProfilePictureImageView.trailingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            userNameLabel.centerYAnchor.constraint(equalTo: userProfilePictureImageView.centerYAnchor),
            
            clothingItemImageViewTopConstraint,
            clothingItemImageView.bottomAnchor.constraint(equalTo: itemNameLabel.topAnchor, constant: -16),
            clothingItemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            clothingItemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            itemNameLabel.leadingAnchor.constraint(equalTo: userProfilePictureImageView.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -10),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: userProfilePictureImageView.leadingAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            buttonsStackView.heightAnchor.constraint(equalTo: userProfilePictureImageView.heightAnchor, multiplier: 0.5),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
