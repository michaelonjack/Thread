//
//  ExploreMainView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreMainView: UIView {
    
    var searchBar: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: .location, placeHolder: "search")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textField.textAlignment = .left
        
        return field
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
        
        addSubview(searchBar)
        addSubview(locationsCollectionView)
        
        setupLayout()
        
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07),
            
            locationsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            locationsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
