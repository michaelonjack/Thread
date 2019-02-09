//
//  ClosetClothingItemsView.swift
//  Thread
//
//  Created by Michael Onjack on 2/3/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class ClosetClothingItemsView: UIView {
    
    var clothingItemCollectionView: UICollectionView = {
        let layout = AnimatedCollectionViewLayout()
        layout.animator = RotateInOutAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.register(ClosetItemCollectionViewCell.self, forCellWithReuseIdentifier: "closetItemCell")
        
        return cv
    }()
    
    var selectorCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0.0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.register(ClosetSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "selectionCell")
        
        return cv
    }()
    
    var colors:[UIColor] = [.ultraLightRed, .ultraLightBlue, .ultraLightGreen, .cream]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        selectorCollectionView.delegate = self
        selectorCollectionView.dataSource = self
        
        addSubview(clothingItemCollectionView)
        addSubview(selectorCollectionView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            clothingItemCollectionView.topAnchor.constraint(equalTo: topAnchor),
            clothingItemCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            clothingItemCollectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            clothingItemCollectionView.heightAnchor.constraint(equalTo: heightAnchor),
            
            selectorCollectionView.topAnchor.constraint(equalTo: topAnchor),
            selectorCollectionView.leadingAnchor.constraint(equalTo: clothingItemCollectionView.trailingAnchor),
            selectorCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}



extension ClosetClothingItemsView: UICollectionViewDelegate {
    
}



extension ClosetClothingItemsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath)
        
        guard let selectionCell = cell as? ClosetSelectionCollectionViewCell else { return cell }
        selectionCell.imageView.backgroundColor = colors[indexPath.row]
        
        return selectionCell
    }
    
}



extension ClosetClothingItemsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 7.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
