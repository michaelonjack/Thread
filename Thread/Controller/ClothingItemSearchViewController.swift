//
//  ClothingItemSearchViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemSearchViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?

    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var resultsTable: ClothingItemTableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var searchResults: [ClothingItem] = []
    var cellsUpdatedForImage: [Bool] = []
    var clothingType: ClothingType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTable.delegate = self
        resultsTable.dataSource = self
        
        searchBarView.searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 6.0
        cancelButton.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func performSearch() {
        view.endEditing(true)
        
        searchResults = []
        
        let searchQuery = searchBarView.searchBar.textField.text ?? ""
        
        APIHelper.searchShopStyle(query: searchQuery, limit: 30) { (result) in
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self.searchResults = []
                break
            case .success(let items):
                self.searchResults = items.map { ClothingItem(shopStyleItem: $0, clothingType: self.clothingType) }
            }
            
            self.cellsUpdatedForImage = []
            (0..<self.searchResults.count).forEach({ (_) in
                self.cellsUpdatedForImage.append(false)
            })
            
            DispatchQueue.main.async {
                self.resultsTable.reloadData()
            }
        }
    }
    
    @IBAction func cancelSearch(_ sender: Any) {
        coordinator?.pop()
    }
}



extension ClothingItemSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = searchResults[indexPath.row]
        self.coordinator?.startEditingDetails(forClothingItem: currentItem)
    }
}



extension ClothingItemSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothingItemTableCell", for: indexPath)
        
        guard let clothingItemCell = cell as? ClothingItemTableViewCell else { return cell }
        
        let clothingItem = searchResults[indexPath.row]
        
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
            
            guard cellsUpdatedForImage[indexPath.row] == false else { return clothingItemCell }
            
            cellsUpdatedForImage[indexPath.row] = true
            
            clothingItem.getImage(ofPreferredSize: .normal) { (itemImage) in
                clothingItemCell.setClothingItemImage(image: itemImage)
                
                // Refreshes the row without reloading the data
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
        return clothingItemCell
    }
}



extension ClothingItemSearchViewController: ClothingItemTableCellDelegate {
    func viewClothingItem(at cell: ClothingItemTableViewCell) {
        guard let indexPath = resultsTable.indexPath(for: cell) else { return }
        
        let currentItem = searchResults[indexPath.row]
        
        if let url = currentItem.itemUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func favoriteItem(at cell: ClothingItemTableViewCell) {
        guard let indexPath = resultsTable.indexPath(for: cell) else { return }
        guard let currentUser = configuration.currentUser else { return }
        
        let currentItem = searchResults[indexPath.row]
        
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
