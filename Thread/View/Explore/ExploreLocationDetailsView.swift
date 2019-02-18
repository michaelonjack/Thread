//
//  ExploreLocationDetailsView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreLocationDetailsView: UIView {
    
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
        clipsToBounds = true
    }
    
    fileprivate func setupView() {
        backgroundColor = .white
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
    }
}
