//
//  HomeViewController+UICollectionView.swift
//  Thread
//
//  Created by Michael Onjack on 3/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == homeView.revealView.closetItemsCollectionView {
            guard let currentUser = configuration.currentUser else { return }
            coordinator?.viewCloset(forUser: currentUser, initialIndex: indexPath.row)
        }
    }
}



extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homeView.revealView.closetItemsCollectionView {
            return 4
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == homeView.revealView.closetItemsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClosetItemCell", for: indexPath)
            
            guard let imageCell = cell as? HomeClosetItemCollectionViewCell else { return cell }
            guard let clothingType = ClothingType(rawValue: indexPath.row) else { return cell }
            
            // Set default values
            imageCell.label.text = clothingType.description
            imageCell.imageView.image = UIImage(named: clothingType.description)
            imageCell.imageView.contentMode = .scaleAspectFit
            
            // Set the item data
            if let item = configuration.currentUser?.clothingItems[clothingType] {
                imageCell.label.text = item.name
                item.getImage(ofPreferredSize: .normal) { (clothingItemImage) in
                    if let itemImage = clothingItemImage {
                        configuration.currentUser?.clothingItems[clothingType]?.itemImage = itemImage
                        imageCell.imageView.image = itemImage
                    }
                }
            }
            
            return imageCell
        }
            
        else {
            fatalError("collecton view not accounted for: \(collectionView)")
        }
    }
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
