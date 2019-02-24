//
//  UserTableView.swift
//  Thread
//
//  Created by Michael Onjack on 2/17/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserTableView: UITableView {
    
    var users: [User] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        dataSource = self
        
        clipsToBounds = true
        rowHeight = frame.height * 0.6
        register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableCell")
    }
}



extension UserTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableCell", for: indexPath)
        
        guard let userCell = cell as? UserTableViewCell else { return cell }
        
        // Reset cell fields
        userCell.userPictureImageView.image = nil
        userCell.userNameLabel.text = ""
        userCell.userStatusLabel.text = ""
        userCell.itemImages = [nil, nil, nil, nil]
        
        let user = users[indexPath.row]
        
        userCell.userNameLabel.text = user.name
        userCell.userStatusLabel.text = user.status ?? "No status"
        user.getProfilePicture { (profilePicture) in
            userCell.userPictureImageView.image = profilePicture
        }
        
        if let userTop = user.clothingItems[.top] {
            userTop.getImage(ofPreferredSize: .small) { (image) in
                user.clothingItems[.top]?.smallItemImage = image
                userCell.itemImages[ClothingType.top.rawValue] = image
                userCell.userClothingItemsView.feedCollectionView.reloadItems(at: [IndexPath(row: ClothingType.top.rawValue, section: 0)])
            }
        }
        
        if let userBottom = user.clothingItems[.bottom] {
            userBottom.getImage(ofPreferredSize: .small) { (image) in
                user.clothingItems[.bottom]?.smallItemImage = image
                userCell.itemImages[ClothingType.bottom.rawValue] = image
                userCell.userClothingItemsView.feedCollectionView.reloadItems(at: [IndexPath(row: ClothingType.bottom.rawValue, section: 0)])
            }
        }
        
        if let userShoes = user.clothingItems[.shoes] {
            userShoes.getImage(ofPreferredSize: .small) { (image) in
                user.clothingItems[.shoes]?.smallItemImage = image
                userCell.itemImages[ClothingType.shoes.rawValue] = image
                userCell.userClothingItemsView.feedCollectionView.reloadItems(at: [IndexPath(row: ClothingType.shoes.rawValue, section: 0)])
            }
        }
        
        if let userAccessories = user.clothingItems[.accessories] {
            userAccessories.getImage(ofPreferredSize: .small) { (image) in
                user.clothingItems[.accessories]?.smallItemImage = image
                userCell.itemImages[ClothingType.accessories.rawValue] = image
                userCell.userClothingItemsView.feedCollectionView.reloadItems(at: [IndexPath(row: ClothingType.accessories.rawValue, section: 0)])
            }
        }
        
        return userCell
    }
}
