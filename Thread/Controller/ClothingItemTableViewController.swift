//
//  ClothingItemTableViewController.swift
//  Thread
//
//  Created by Michael Onjack on 3/19/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemTableViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?
    
    @IBOutlet weak var navigationHeader: NavigationHeaderView!
    @IBOutlet weak var clothingItemTableView: ClothingItemTableView!
    
    var navigationText: String!
    var titleText: String!
    
    var clothingItems: [ClothingItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationHeader.backButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        navigationHeader.previousViewLabel.text = navigationText
        navigationHeader.currentViewLabel.text = titleText

        clothingItemTableView.delegate = self
        clothingItemTableView.dataSource = self
        clothingItemTableView.reloadData()
    }
    
    @objc func dismiss(_ sender: Any) {
        coordinator?.pop()
    }
}



extension ClothingItemTableViewController: UITableViewDelegate {
    
}



extension ClothingItemTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothingItemTableCell", for: indexPath)
        
        guard let clothingItemCell = cell as? ClothingItemTableViewCell else { return cell }
        
        let clothingItem = clothingItems[indexPath.row]
        
        clothingItemCell.delegate = self
        clothingItemCell.clothingItemImageView.image = nil
        clothingItemCell.itemNameLabel.text = clothingItem.name
        
        // Determine if the current user has favorited the item
        if configuration.currentUser?.favoritedItems.contains(clothingItem) ?? false {
            clothingItemCell.favoriteButton.isSelected = true
        } else {
            clothingItemCell.favoriteButton.isSelected = false
        }
        
        if let itemImage = clothingItem.itemImage {
            clothingItemCell.setClothingItemImage(image: itemImage)
        } else {
            clothingItem.getImage(ofPreferredSize: .normal) { (itemImage) in
                clothingItemCell.setClothingItemImage(image: itemImage)
                
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
        return clothingItemCell
    }
}



extension ClothingItemTableViewController: ClothingItemTableCellDelegate {
    func viewClothingItem(at cell: ClothingItemTableViewCell) {
        guard let indexPath = clothingItemTableView.indexPath(for: cell) else { return }
        
        let currentItem = clothingItems[indexPath.row]
        
        if let url = currentItem.itemUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func favoriteItem(at cell: ClothingItemTableViewCell) {
        guard let indexPath = clothingItemTableView.indexPath(for: cell) else { return }
        guard let currentUser = configuration.currentUser else { return }
        
        let currentItem = clothingItems[indexPath.row]
        
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
