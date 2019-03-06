//
//  HomeUpdateView.swift
//  Thread
//
//  Created by Michael Onjack on 3/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeRevealView: UIView {
    
    var doneButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .black
        b.setTitle("Done", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.clipsToBounds = true
        
        return b
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
        
        doneButton.layer.cornerRadius = doneButton.frame.height / 5.0
    }
    
    fileprivate func setupView() {
        
        addSubview(doneButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            doneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            doneButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07)
        ])
    }
}
