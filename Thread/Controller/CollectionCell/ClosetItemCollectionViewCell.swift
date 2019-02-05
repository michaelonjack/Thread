//
//  ClosetItemCollectionViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/3/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClosetItemCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Medium", size: 35.0)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        
        return label
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
        
        addSubview(imageView)
        addSubview(label)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.92),
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.16)
        ])
    }
}
