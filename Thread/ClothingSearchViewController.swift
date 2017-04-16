//
//  ClothingSearchViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/6/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class ClothingSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var loadingAnimationView: NVActivityIndicatorView!
    @IBOutlet weak var textFieldQuery: UITextField!
    @IBOutlet weak var tableviewResults: UITableView!
    
    let unwindToClothingItem = "UnwindToClothingItem"
    let shopStyleAPIKey = valueForAPIKey(keyname: "ShopStyle")
    let shopStlyeEndpoint = "https://api.shopstyle.com/api/v2/products?pid="
    
    var clothingSearchResults: [ClothingItem] = []
    var totalNumberOfProductsFound: Int = 0
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewResults.delegate = self
        tableviewResults.dataSource = self
        
        tableviewResults.rowHeight = UITableViewAutomaticDimension
        tableviewResults.estimatedRowHeight = 300
        
        //Looks for single or multiple taps and hides keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ClothingSearchViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  searchDidTouch
    //
    //  Handles the action when the user presses the Search button
    //  Makes the API call and modifies the table view using the returned data
    //
    @IBAction func searchDidTouch(_ sender: Any) {
        loadingAnimationView.type = .ballBeat
        loadingAnimationView.startAnimating()
        view.endEditing(true)
        
        let query = textFieldQuery.text
        if query != nil && query != "" {
            
            clothingSearchResults.removeAll()
            tableviewResults.reloadData()
            
            // Session Configuration
            let config = URLSessionConfiguration.default
            // Load configuration into Session
            let session = URLSession(configuration: config)
            
            let encodedQuery = query?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let urlString = shopStlyeEndpoint + shopStyleAPIKey + "&fts=" + encodedQuery! + "&limit=25"
            let url = URL(string: urlString)!
            
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error == nil {
                    
                    let jsonResponse = JSON(data: data!)
                    self.totalNumberOfProductsFound = jsonResponse["metadata"]["total"].int! > 25 ? 25 : jsonResponse["metadata"]["total"].int!
                    
                    for (key, subJson):(String, JSON) in jsonResponse["products"] {
                        let itemId = String(subJson["id"].int64 ?? -1)
                        
                        let itemName = subJson["name"].string ?? ""
                        
                        let itemUrl = subJson["clickUrl"].string?.replacingOccurrences(of: "\\/", with: "/") ?? ""
                        
                        let itemBrand = subJson["brand"]["name"].string ?? ""
                        
                        let picUrl =  subJson["image"]["sizes"]["IPhone"]["url"].string?.replacingOccurrences(of: "\\/", with: "/")
                        
                        
                        self.clothingSearchResults.append( ClothingItem(id: itemId, name: itemName, brand: itemBrand, itemUrl: itemUrl) )
                        self.downloadImageFromUrl(url: picUrl!, index: Int(key)!)
                        
                    }
                    
                } else {
                    print(error!.localizedDescription)
                }
                
            })
            task.resume()
        } else {
            loadingAnimationView.stopAnimating()
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // tableView -- numberOfRowsInSection
    //
    //  Returns the number of rows in the table (uses the clothingSearchResults array as data source)
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingSearchResults.count
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- cellForRowAt
    //
    //  Determines what information is to be displayed in each table cell
    //  Uses the ClothingItem at the matching index of clothingSearchResults to set the cell's information
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClothingItemTableViewCell
        
        cell.labelInfo.text = clothingSearchResults[indexPath.row].name
        cell.labelLink.text = "Select For Link >"
        let clothingPic = clothingSearchResults[indexPath.row].itemImage == nil ? UIImage(named: "Placeholder") : clothingSearchResults[indexPath.row].itemImage!
        cell.imageViewClothingPic.image = clothingPic
        
        return cell
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- canEditRowAt
    //
    //  Determines if the cell can be edited (No cells in this table are editable)
    //
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- didSelectRowAt
    //
    //  Segues the selected clothing item back to the user's profile and occupies the view with its data
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if clothingSearchResults[indexPath.row].isExpanded {
            self.performSegue(withIdentifier: self.unwindToClothingItem, sender: clothingSearchResults[indexPath.row])
        } else {
            
            for index in 0 ..< clothingSearchResults.count {
                clothingSearchResults[index].isExpanded = false
            }
            
            // Ask table view for a reference to the selected cell
            guard let cell = tableView.cellForRow(at: indexPath) as? ClothingItemTableViewCell else { return }
            
            var item = clothingSearchResults[indexPath.row]
            
            // Change the isExpanded state of the item to show that the user has selected it
            item.isExpanded = !item.isExpanded
            clothingSearchResults[indexPath.row] = item
            
            // If the cell is expanded, show the full link. Otherwise show the instructions to expand the link
            cell.labelLink.text = item.itemUrl + "\n\nSelect again to choose"
            
            // Ask the table view to refresh the cell heights
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // Tell the table view to scroll the selected row to the top of the table view in an animated fashion
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  downloadImageFromUrl
    //
    //  Takes in a string url and downloads the image found at that url and gives its value to the owning clothing item in the clothingSearchResults array
    //
    func downloadImageFromUrl(url: String, index: Int) {
        
        let clothingPictureURL = URL(string:url)
        let session = URLSession(configuration: .default)
        let downloadTask = session.dataTask(with: clothingPictureURL!) { (data, response, error) in
            if error == nil {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        self.clothingSearchResults[index].itemImage = UIImage(data: imageData)
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Error downloading image")
            }
            
            // Once all of the images have been downloaded and set, refresh the table view
            if self.totalNumberOfProductsFound-1 == index {
                DispatchQueue.main.async {
                    self.tableviewResults.reloadData()
                    self.loadingAnimationView.stopAnimating()
                }
            }
        }
        downloadTask.resume()
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    /////////////////////////////////////////////////////
    //
    //  prepareForSegue
    //
    //  Unwindes to the previous view controller (ClothingItemViewController) and sets it view to hold the selected ClothingItem data
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.unwindToClothingItem {
            let clothingItemVC = segue.destination as! ClothingItemViewController
            let selectedItem = sender as! ClothingItem
            
            clothingItemVC.clothingItem.setName(name: selectedItem.name)
            clothingItemVC.clothingItem.setBrand(brand: selectedItem.brand)
            clothingItemVC.clothingItem.setItemUrl(url: selectedItem.itemUrl)
            clothingItemVC.imageViewClothingPicture.image = selectedItem.itemImage
            clothingItemVC.imageViewClothingPicture.contentMode = .scaleAspectFit
            clothingItemVC.imageDidChange = true
            
        }
    }
 

}
