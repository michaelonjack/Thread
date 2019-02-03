//
//  FeedCollectionViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/3/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let shadowView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    fileprivate func setupView() {
        
        addSubview(shadowView)
        shadowView.addSubview(imageView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor)
        ])
    }
}
