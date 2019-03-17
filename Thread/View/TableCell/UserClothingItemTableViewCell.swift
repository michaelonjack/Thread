//
//  UserClothingItemTableViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 3/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserClothingItemTableViewCell: UITableViewCell {
    
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
    
    var clothingItemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        
        return iv
    }()
    
    var buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.spacing = 8
        
        return sv
    }()
    
    var favoriteButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "Favorite"), for: .normal)
        b.setImage(UIImage(named: "FavoriteClicked"), for: UIControl.State.selected)
        b.imageView?.contentMode = .scaleAspectFit
        
        return b
    }()
    
    var viewInBrowserButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "Browser"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        
        return b
    }()
    
    var clothingItemImageHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userProfilePictureImageView.layer.cornerRadius = userProfilePictureImageView.frame.height / 2
    }
    
    fileprivate func setupView() {
        selectionStyle = .none
        
        buttonsStackView.addArrangedSubview(favoriteButton)
        buttonsStackView.addArrangedSubview(viewInBrowserButton)
        
        addSubview(userProfilePictureImageView)
        addSubview(userNameLabel)
        addSubview(clothingItemImageView)
        addSubview(buttonsStackView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
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
            clothingItemImageView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -16),
            clothingItemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            clothingItemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: userProfilePictureImageView.leadingAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            buttonsStackView.heightAnchor.constraint(equalTo: userProfilePictureImageView.heightAnchor, multiplier: 0.5),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setClothingItemImage(image: UIImage) {
        if let imageHeightConstraint = clothingItemImageHeightConstraint {
            imageHeightConstraint.isActive = false
        }
        
        let aspectRatio = image.size.height / image.size.width
        
        clothingItemImageHeightConstraint = clothingItemImageView.heightAnchor.constraint(equalTo: clothingItemImageView.widthAnchor, multiplier: aspectRatio)
        clothingItemImageHeightConstraint?.priority = UILayoutPriority(rawValue: 999)
        clothingItemImageHeightConstraint?.isActive = true
        layoutIfNeeded()
        
        clothingItemImageView.image = image
    }
}
