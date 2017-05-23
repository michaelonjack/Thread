//
//  FavoritesTableViewController.swift
//  Thread
//
//  Created by Michael Onjack on 4/16/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    
    var favoriteItems: [ClothingItem] = []
    var numFavoritedItems: Int = 0
    var itemsProcessed: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        
        // Set the font of the navigation bar's header
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Avenir-Book", size: 20)!,
            NSForegroundColorAttributeName: UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
        ]
        
        // Fetch the current user's favorited items
        self.currentUserRef.child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.numFavoritedItems = Int(snapshot.childrenCount)
            
            for (index, clothingItem) in snapshot.children.enumerated() {
                
                // Create instance of the favorited item
                let currentItem = ClothingItem(snapshot: clothingItem as! DataSnapshot)
                // Download the item's image using the URL
                self.downloadImageFromUrl(url: currentItem.itemPictureUrl, index: index)
                
                self.favoriteItems.append(currentItem)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  downloadImageFromUrl
    //
    //  Takes in a string url and downloads the image found at that url and gives its value to the owning clothing item in the favoriteItems array
    //
    func downloadImageFromUrl(url: String, index: Int) {
        
        let clothingPictureURL = URL(string:url)
        let session = URLSession(configuration: .default)
        let downloadTask = session.dataTask(with: clothingPictureURL!) { (data, response, error) in
            if error == nil {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        self.favoriteItems[index].itemImage = UIImage(data: imageData)
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Error downloading image")
            }
            
            self.itemsProcessed += 1
            
            // Once all of the images have been downloaded and set, refresh the table view
            if self.numFavoritedItems == self.itemsProcessed {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
 
        }
        downloadTask.resume()
        
    }
    
    

    /////////////////////////////////////////////////////
    //
    //  tableView - numberOfRowsInSection
    //
    //  Returns the number of rows in the table
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItems.count
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- canEditRowAt
    //
    //  Determines if the cell can be edited
    //
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- didSelectRowAt
    //
    //  Opens the selected item's url
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let clothingItem = favoriteItems[indexPath.row]
        
        if clothingItem.itemUrl != "" {
            let itemUrl = URL(string: clothingItem.itemUrl)!
            UIApplication.shared.open(itemUrl)
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView - cellForRowAt
    //
    //
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothingItemCell", for: indexPath) as! ClothingItemTableViewCell
        
        let clothingItem = favoriteItems[indexPath.row]
        
        cell.labelInfo.text = clothingItem.name
        
        cell.imageViewClothingPic.image = clothingItem.itemImage == nil ? UIImage(named: "Favorite") : clothingItem.itemImage
        cell.imageViewClothingPic.contentMode = .scaleAspectFit
        
        return cell
    }
    
    
    

}



