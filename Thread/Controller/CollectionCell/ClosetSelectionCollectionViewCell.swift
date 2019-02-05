//
//  ClosetSelectionCollectionViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/3/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClosetSelectionCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        imageView.layer.cornerRadius = imageView.frame.height / 2.0
        imageView.clipsToBounds = true
    }
    
    fileprivate func setupView() {
        
        addSubview(imageView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
