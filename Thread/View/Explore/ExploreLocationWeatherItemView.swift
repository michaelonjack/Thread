//
//  ExploreLocationWeatherItemView.swift
//  Thread
//
//  Created by Michael Onjack on 4/15/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreLocationWeatherItemView: UIView {
    
    var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    var itemLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Regular", size: 13.0)
        l.textColor = .black
        l.textAlignment = .center
        l.numberOfLines = 2
        
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
    
    fileprivate func setupView() {
        
        addSubview(itemImageView)
        addSubview(itemLabel)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: topAnchor),
            itemImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor),
            itemImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            itemLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
