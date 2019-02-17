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
    @IBOutlet weak var cancelButton: UIButton!
    
    var searchResults: [ClothingItem] = []
    var clothingType: ClothingType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTable.coordinator = coordinator
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
                self.resultsTable.clothingItems = self.searchResults
                self.resultsTable.reloadData()
                self.resultsTable.scrollToTop()
            }
        }
    }
    
    @IBAction func cancelSearch(_ sender: Any) {
        coordinator?.pop()
    }
}
