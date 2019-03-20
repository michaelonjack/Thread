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

    @IBOutlet weak var searchBar: SearchBarView!
    @IBOutlet weak var resultsTable: ClothingItemTableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var searchResults: [ClothingItem] = []
    var clothingType: ClothingType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTable.delegate = self
        resultsTable.dataSource = self
        
        searchBar.searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
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
        
        let searchQuery = searchBar.searchBarView.textField.text ?? ""
        
        APIHelper.searchShopStyle(query: searchQuery, limit: 30) { (items, error) in
            if error != nil {
                print(error.debugDescription)
            }
            
            self.searchResults = items.map { ClothingItem(shopStyleItem: $0, clothingType: self.clothingType) }
            
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
}
