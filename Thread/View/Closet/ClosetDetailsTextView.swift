//
//  ClosetDetailsTextView.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClosetDetailsTextView: UIView {
    
    var detailsTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .left
        tv.textColor = .black
        tv.showsVerticalScrollIndicator = true
        tv.isScrollEnabled = true
        tv.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        tv.isEditable = false
        
        return tv
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
        
        addSubview(detailsTextView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            detailsTextView.topAnchor.constraint(equalTo: topAnchor),
            detailsTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailsTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            detailsTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
