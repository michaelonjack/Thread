//
//  RoundedImageCollectionViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 3/10/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class RoundedImageCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        
        return iv
    }()
    
    let shadowView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        
        return v
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
        
        shadowView.layer.cornerRadius = shadowView.frame.height / 2.0
        imageView.layer.cornerRadius = imageView.frame.height / 2.0
    }
    
    fileprivate func setupView() {
        
        clipsToBounds = true
        
        addSubview(shadowView)
        addSubview(imageView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            shadowView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            shadowView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
}
