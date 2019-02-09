//
//  ClosetDetailsTextView.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClosetDetailsTextView: UIView {
    
    var detailsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.textColor = .black
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 0
        l.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        
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
        
        addSubview(detailsLabel)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            detailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
