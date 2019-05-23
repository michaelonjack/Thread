//
//  ExploreMainView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreMainView: UIView {
    
    var searchBarView: SearchBarView = {
        let searchView = SearchBarView(frame: .zero)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        return searchView
    }()
    
    var locationsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.backgroundColor = .clear
        cv.register(ExploreLocationCollectionViewCell.self, forCellWithReuseIdentifier: "LocationCell")
        
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
        
        addSubview(searchBarView)
        addSubview(locationsCollectionView)
        
        setupLayout()
        
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBarView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            locationsCollectionView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            locationsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
