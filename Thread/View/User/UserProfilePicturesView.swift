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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        addSubview(picturesCollectionView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            picturesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            picturesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            picturesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            picturesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
