//
//  HomeViewController+UITableView.swift
//  Thread
//
//  Created by Michael Onjack on 3/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemOwner = followedItems[indexPath.row].0
        let currentItem = followedItems[indexPath.row].1
        
        coordinator?.viewCloset(forUser: itemOwner, initialIndex: currentItem.type.rawValue)
    }
}



extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserClothingItemCell", for: indexPath)
        
        guard let userItemCell = cell as? UserClothingItemTableViewCell else { return cell }
        
        let itemOwner = followedItems[indexPath.row].0
        let currentItem = followedItems[indexPath.row].1
        
        userItemCell.delegate = self
        userItemCell.userNameLabel.text = itemOwner.name
        userItemCell.itemNameLabel.text = currentItem.name
        itemOwner.getProfilePicture { (profilePicture) in
            userItemCell.userProfilePictureImageView.image = profilePicture
        }
        
        // Determine if the current user has favorited the item
        if configuration.currentUser?.favoritedItems.contains(currentItem) ?? false {
            userItemCell.favoriteButton.isSelected = true
        } else {
            userItemCell.favoriteButton.isSelected = false
        }
        
        if let itemImage = currentItem.itemImage {
            userItemCell.setClothingItemImage(image: itemImage)
        } else {
            currentItem.getImage(ofPreferredSize: .normal, completion: { (itemImage) in
                userItemCell.setClothingItemImage(image: itemImage)
                
                tableView.beginUpdates()
                tableView.endUpdates()
            })
        }
        
        return userItemCell
    }
}



extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == homeView.followingView.itemsTableView else { return }
        
        // If we haven't yet reached the maximum Y value for the pannable view, don't allow the table view to scroll
        if !homeView.maxYReached {
            scrollView.contentOffset.y = 0.0
        }
        
        // If the tableview is at the top and scrolling down, stop the scrolling because this means it's time pan the view down
        else if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0.0
        }
    }
}



extension HomeViewController: ClothingItemTableCellDelegate {
    func viewClothingItem(at cell: ClothingItemTableViewCell) {
        
        guard let indexPath = homeView.followingView.itemsTableView.indexPath(for: cell) else { return }
        
        let currentItem = followedItems[indexPath.row].1
        
        if let url = currentItem.itemUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func favoriteItem(at cell: ClothingItemTableViewCell) {
        guard let indexPath = homeView.followingView.itemsTableView.indexPath(for: cell) else { return }
        guard let currentUser = configuration.currentUser else { return }
        
        let currentItem = followedItems[indexPath.row].1
        
        // User currently has the item in their favorites so they're un-favoriting the item
        if currentUser.favoritedItems.contains(currentItem) {
            currentUser.favoritedItems.removeAll(where: { $0 == currentItem })
            
            cell.favoriteButton.isSelected = false
        }
        
        // User is requesting to add the item to their favorites
        else {
            currentUser.favoritedItems.append(currentItem)
            
            cell.favoriteButton.isSelected = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                cell.favoriteButton.transform = cell.favoriteButton.transform.scaledBy(x: 2, y: 2)
            }) { (_) in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    cell.favoriteButton.transform = cell.favoriteButton.transform.scaledBy(x: 0.5, y: 0.5)
                })
            }
        }
    }
}
