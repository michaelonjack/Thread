//
//  ClothingItemSwipeView.swift
//  Thread
//
//  Created by Michael Onjack on 2/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemSwipeView: SwipeView {
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    override func setupView() {
        super.setupView()
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDoubleTapped))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
        
        addSubview(imageView)
        
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc func viewDoubleTapped(_ gesture: UITapGestureRecognizer) {
        print("double tapped")
    }
}
