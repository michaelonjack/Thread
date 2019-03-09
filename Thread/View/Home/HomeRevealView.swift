//
//  HomeUpdateView.swift
//  Thread
//
//  Created by Michael Onjack on 3/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class HomeRevealView: UIView {
    
    var closetItemsCollectionView: UICollectionView = {
        let layout = AnimatedCollectionViewLayout()
        layout.animator = RotateInOutAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.register(HomeClosetItemCollectionViewCell.self, forCellWithReuseIdentifier: "ClosetItemCell")
        
        return cv
    }()
    
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
        
        addSubview(closetItemsCollectionView)
        addSubview(doneButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            closetItemsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            closetItemsCollectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.89),
            closetItemsCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.87),
            closetItemsCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            doneButton.topAnchor.constraint(equalTo: closetItemsCollectionView.bottomAnchor, constant: 16),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            doneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            doneButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75)
        ])
    }
}
