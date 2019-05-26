//
//  ClosetViewController+UICollectionView.swift
//  Thread
//
//  Created by Michael Onjack on 3/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

extension ClosetViewController: UICollectionViewDelegate {
    
}



extension ClosetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clothingItemsView.clothingItemCollectionView {
            return 4
        }
        
        else if collectionView == detailsView.tagsView.tagsCollectionView {
            guard let clothingType = ClothingType(rawValue: currentItemIndex) else { return 0 }
            guard let clothingItem = user?.clothingItems[clothingType] else { return 0 }
            
            return clothingItem.tags.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clothingItemsView.clothingItemCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "closetItemCell", for: indexPath)
            
            guard let closetItemCell = cell as? ClosetItemCollectionViewCell else { return cell }
            guard let clothingType = ClothingType(rawValue: indexPath.row) else { return cell }
            
            // Set default values
            closetItemCell.imageView.image = UIImage(named: clothingType.description)
            closetItemCell.label.text = "No Price"
            closetItemCell.imageView.contentMode = .scaleAspectFit
            
            if let item = user?.clothingItems[clothingType] {
                
                if let price = item.price {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .currency
                    let priceStr = formatter.string(from: price as NSNumber) ?? "No Price"
                    
                    closetItemCell.label.text = priceStr
                }
                
                item.getImage(ofPreferredSize: .normal) { (itemImage) in
                    closetItemCell.imageView.image = itemImage
                }
            }
            
            return closetItemCell
        }
        
        else if collectionView == detailsView.tagsView.tagsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath)
            
            guard let tagCell = cell as? ClosetTagCollectionViewCell else { return cell }
            tagCell.backgroundColor = .black
            tagCell.label.text = ""
            
            if let clothingType = ClothingType(rawValue: currentItemIndex), let clothingItem = user?.clothingItems[clothingType] {
                tagCell.label.text = clothingItem.tags[indexPath.row].name
            }
            
            return tagCell
        }
        
        fatalError("Collection view not accounted for")
    }
    
}



extension ClosetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == clothingItemsView.clothingItemCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
        else if collectionView == detailsView.tagsView.tagsCollectionView {
            
            if let clothingType = ClothingType(rawValue: currentItemIndex), let clothingItem = user?.clothingItems[clothingType] {
                // Calculate the width necessary to fit the current text
                let tagText = clothingItem.tags[indexPath.row].name as NSString
                let textSize = tagText.size(withAttributes: [.font: ClosetTagCollectionViewCell.cellFont!])
                
                return CGSize(width: textSize.width + 32, height: textSize.height + 10)
            }
            
            else {
                return CGSize(width: collectionView.frame.width * 0.90, height: collectionView.frame.height * 0.333)
            }
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == clothingItemsView.clothingItemCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        else if collectionView == detailsView.tagsView.tagsCollectionView {
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        
        return UIEdgeInsets.zero
    }
}
