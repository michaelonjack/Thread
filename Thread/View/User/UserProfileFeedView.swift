//
//  UserProfileFeedView.swift
//  Thread
//
//  Created by Michael Onjack on 2/2/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserProfileFeedView: UIView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AvenirNext-Medium", size: 16.0)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Closet"
        
        return label
    }()
    
    var viewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
        button.setTitle("view", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        
        return button
    }()
    
    var feedCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20.0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "feedCell")
        
        return cv
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
        
        addSubview(titleLabel)
        addSubview(viewButton)
        addSubview(feedCollectionView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            viewButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            viewButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            viewButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18),
            viewButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            feedCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            feedCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            feedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            feedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
