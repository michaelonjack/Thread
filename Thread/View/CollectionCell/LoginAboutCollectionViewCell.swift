//
//  LoginAboutCollectionViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/7/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class LoginAboutCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    var imageViewContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
        
    }()
    
    var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.numberOfLines = 0
        l.textColor = .white
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Regular", size: 20.0)
        
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
        
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.height / 2.0
        imageViewContainer.clipsToBounds = true
    }
    
    fileprivate func setupView() {
        
        backgroundColor = .clear
        
        addSubview(imageViewContainer)
        addSubview(label)
        
        imageViewContainer.addSubview(imageView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            imageViewContainer.topAnchor.constraint(equalTo: topAnchor),
            imageViewContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageViewContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            imageViewContainer.widthAnchor.constraint(equalTo: imageViewContainer.heightAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: imageViewContainer.heightAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageViewContainer.heightAnchor, multiplier: 0.7),
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: imageViewContainer.bottomAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
