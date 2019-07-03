//
//  HomeFollowingUsersView.swift
//  Thread
//
//  Created by Michael Onjack on 3/10/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeFollowingUsersView: UIView {
    
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
    
    var itemsLabelContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        
        return v
    }()
    
    var itemsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.text = "New Items"
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        l.textAlignment = .left
        
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
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        addSubview(followingLabel)
        addSubview(followingUsersCollectionView)
        addSubview(divider)
        addSubview(itemsLabelContainerView)
        itemsLabelContainerView.addSubview(itemsLabel)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            followingLabel.topAnchor.constraint(equalTo: topAnchor),
            followingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            followingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            followingUsersCollectionView.topAnchor.constraint(equalTo: followingLabel.bottomAnchor),
            followingUsersCollectionView.bottomAnchor.constraint(equalTo: divider.topAnchor),
            followingUsersCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            followingUsersCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            divider.bottomAnchor.constraint(equalTo: itemsLabel.topAnchor, constant: -8),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            itemsLabelContainerView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            itemsLabelContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemsLabelContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemsLabelContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            itemsLabel.leadingAnchor.constraint(equalTo: followingLabel.leadingAnchor),
            itemsLabel.trailingAnchor.constraint(equalTo: followingLabel.trailingAnchor),
            itemsLabel.bottomAnchor.constraint(equalTo: itemsLabelContainerView.bottomAnchor)
        ])
    }
}
