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

    @IBOutlet weak var searchBar: ClothingItemSearchBar!
    @IBOutlet weak var resultsTable: ClothingItemTableView!
    
    var searchResults: [ClothingItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
    }
    
    @objc func performSearch() {
        
        searchResults = []
        let searchQuery = searchBar.searchBarView.textField.text ?? ""
        
        APIHelper.searchShopStyle(query: searchQuery, limit: 30) { (items, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            self.searchResults = items
            
            DispatchQueue.main.async {
                self.resultsTable.clothingItems = self.searchResults
                self.resultsTable.itemsTableView.reloadData()
            }
        }
        
    }
}
