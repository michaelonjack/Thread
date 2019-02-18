//
//  ExploreLocationsView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreLocationsView: UIView {
    
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
        
        locationsCollectionView.delegate = self
        locationsCollectionView.dataSource = self
        
        addSubview(locationsCollectionView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            locationsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            locationsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}



extension ExploreLocationsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ExploreLocationCollectionViewCell else { return }
        guard let rootView = selectedCell.window?.subviews[0] else { return }
        
        
        let originInParent = selectedCell.convert(CGPoint(x: 0, y: 0), to: rootView)
        let frameInRootView = CGRect(x: originInParent.x, y: originInParent.y, width: selectedCell.frame.width, height: selectedCell.frame.height)
        
        let locationTopView = ExploreLocationTopView(frame: frameInRootView)
        locationTopView.translatesAutoresizingMaskIntoConstraints = false
        locationTopView.locationImageView.image = selectedCell.imageView.image
        
        rootView.addSubview(locationTopView)
        locationTopView.animateOpening()
    }
}



extension ExploreLocationsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath)
        
        guard let imageCell = cell as? ExploreLocationCollectionViewCell else { return cell }
        
        imageCell.imageView.contentMode = .scaleAspectFill
        
        switch indexPath.row {
        case 0:
            imageCell.imageView.image = UIImage(named: "dc")
        case 1:
            imageCell.imageView.image = UIImage(named: "philly")
        case 2:
            imageCell.imageView.image = UIImage(named: "ny")
        case 3:
            imageCell.imageView.image = UIImage(named: "la")
        default:
            break
        }
        
        return imageCell
    }
    
    
}



extension ExploreLocationsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: collectionView.frame.height * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
