//
//  HomeViewController+UITableView.swift
//  Thread
//
//  Created by Michael Onjack on 3/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDelegate {
    
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
        
        userItemCell.userNameLabel.text = itemOwner.name
        itemOwner.getProfilePicture { (profilePicture) in
            userItemCell.userProfilePictureImageView.image = profilePicture
        }
        
        if let itemImage = currentItem.itemImage {
            userItemCell.setClothingItemImage(image: itemImage)
        } else {
            currentItem.getImage(ofPreferredSize: .normal, completion: { (itemImage) in
                if let itemImage = itemImage {
                    self.followedItems[indexPath.row].1.itemImage = itemImage
                    userItemCell.setClothingItemImage(image: itemImage)
                    tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
            })
        }
        
        return userItemCell
    }
    
    
}
