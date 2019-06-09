//
//  UserProfilePicturesView.swift
//  Thread
//
//  Created by Michael Onjack on 6/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserProfilePicturesView: UIView {
    
    let picturesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ProfilePictureCell")
        
        return cv
    }()
    
    let indicatorTrackView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0, alpha: 0.3)
        v.clipsToBounds = true
        
        return v
    }()
    
    let indicatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 1, alpha: 0.7)
        v.clipsToBounds = true
        
        return v
    }()
    
    var indicatorWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorTrackView.layer.cornerRadius = indicatorTrackView.frame.height / 2
        indicatorView.layer.cornerRadius = indicatorView.frame.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        addSubview(picturesCollectionView)
        addSubview(indicatorTrackView)
        addSubview(indicatorView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalTo: indicatorTrackView.widthAnchor)
        
        NSLayoutConstraint.activate([
            picturesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            picturesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            picturesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            picturesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            indicatorTrackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            indicatorTrackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorTrackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            indicatorTrackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.012),
            
            indicatorView.topAnchor.constraint(equalTo: indicatorTrackView.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: indicatorTrackView.bottomAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: indicatorTrackView.leadingAnchor),
            indicatorWidthConstraint
        ])
    }
    
}
