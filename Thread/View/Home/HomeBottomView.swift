//
//  HomeBottomView.swift
//  Thread
//
//  Created by Michael Onjack on 3/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeBottomView: UIView {
    
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
        
        layer.cornerRadius = frame.height / 10.0
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    fileprivate func setupView() {
        backgroundColor = .black
        clipsToBounds = true
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
    }
}
