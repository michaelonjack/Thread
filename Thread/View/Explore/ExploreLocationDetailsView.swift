//
//  ExploreLocationDetailsView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreLocationDetailsView: UIView {
    
    var pullIndicator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lighterGray
        v.clipsToBounds = true
        v.layer.cornerRadius = 4
        
        return v
    }()
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Medium", size: 30.0)
        
        return l
    }()
    
    var blurbLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 0
        l.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
        
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
        
        layer.cornerRadius = frame.height / 20.0
    }
    
    fileprivate func setupView() {
        backgroundColor = .white
        clipsToBounds = true
        
        addSubview(pullIndicator)
        addSubview(nameLabel)
        addSubview(blurbLabel)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            pullIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            pullIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            pullIndicator.heightAnchor.constraint(equalToConstant: 8),
            pullIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            
            nameLabel.topAnchor.constraint(equalTo: pullIndicator.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            blurbLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            blurbLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            blurbLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
}
