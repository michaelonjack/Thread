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
            clothingItem.getImage(ofPreferredSize: .normal) { (image) in
                if let itemImage = image {
                    clothingItemCell.setClothingItemImage(image: itemImage)
                    tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                }
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
}
