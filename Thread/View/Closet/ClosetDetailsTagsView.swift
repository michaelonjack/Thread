//
//  ClosetDetailsTagsView.swift
//  Thread
//
//  Created by Michael Onjack on 3/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClosetDetailsTagsView: UIView {
    
    var tagsCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        
        var cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = false
        cv.backgroundColor = .white
        cv.register(ClosetTagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        
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
        
        backgroundColor = .white
        
        addSubview(tagsCollectionView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            tagsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            tagsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
