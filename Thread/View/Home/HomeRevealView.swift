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
    
    var hideLocationButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .black
        b.setTitle("Hide Location", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.clipsToBounds = true
        
        return b
    }()
    
    var checkInButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .black
        b.setTitle("Check In", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.clipsToBounds = true
        
        return b
    }()
    
    var buttonsStackView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.spacing = 8
        
        return sv
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
        
        hideLocationButton.layer.cornerRadius = buttonsStackView.frame.height / 5.0
        checkInButton.layer.cornerRadius = buttonsStackView.frame.height / 5.0
    }
    
    fileprivate func setupView() {
        
        buttonsStackView.addArrangedSubview(hideLocationButton)
        buttonsStackView.addArrangedSubview(checkInButton)
        
        addSubview(closetItemsCollectionView)
        addSubview(buttonsStackView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            closetItemsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            closetItemsCollectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.89),
            closetItemsCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.87),
            closetItemsCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            buttonsStackView.topAnchor.constraint(equalTo: closetItemsCollectionView.bottomAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
}
