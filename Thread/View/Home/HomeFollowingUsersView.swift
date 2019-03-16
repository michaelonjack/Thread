//
//  HomeFollowingUsersView.swift
//  Thread
//
//  Created by Michael Onjack on 3/10/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeFollowingUsersView: UIView {
    
    var pullIndicator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lighterGray
        v.clipsToBounds = true
        v.layer.cornerRadius = 4
        
        return v
    }()
    
    var followingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.text = "Following"
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        l.textAlignment = .left
        
        return l
    }()
    
    var followingUsersCollectionView: UICollectionView = {
       let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 15
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.register(RoundedImageCollectionViewCell.self, forCellWithReuseIdentifier: "HomeFollowingUserCell")
        
        return cv
    }()
    
    var divider: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        return v
    }()
    
    var pullIndicatorHeightConstraint: NSLayoutConstraint!
    var pullIndicatorTopConstraint: NSLayoutConstraint!
    var pullIndicatorBottomConstraint: NSLayoutConstraint!
    
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
        
        layer.cornerRadius = frame.height / 4
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    fileprivate func setupView() {
        clipsToBounds = true
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        addSubview(pullIndicator)
        addSubview(followingLabel)
        addSubview(followingUsersCollectionView)
        addSubview(divider)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        pullIndicatorTopConstraint = pullIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        pullIndicatorBottomConstraint = followingLabel.topAnchor.constraint(equalTo: pullIndicator.bottomAnchor, constant: 8)
        pullIndicatorHeightConstraint = pullIndicator.heightAnchor.constraint(equalToConstant: 8)
        
        NSLayoutConstraint.activate([
            pullIndicatorTopConstraint,
            pullIndicatorHeightConstraint,
            pullIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            pullIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pullIndicatorBottomConstraint,
            followingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            followingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            followingUsersCollectionView.topAnchor.constraint(equalTo: followingLabel.bottomAnchor),
            followingUsersCollectionView.bottomAnchor.constraint(equalTo: divider.topAnchor),
            followingUsersCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            followingUsersCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
