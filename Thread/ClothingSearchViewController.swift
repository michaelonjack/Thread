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
    
    let shopStyleAPIKey = valueForAPIKey(keyname: "ShopStyle")
    let shopStlyeEndpoint = "https://api.shopstyle.com/api/v2/products?pid="
    
    var clothingSearchResults: [ClothingItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewResults.delegate = self
        tableviewResults.dataSource = self
        
        tableviewResults.rowHeight = UITableViewAutomaticDimension
        tableviewResults.estimatedRowHeight = 300
        
        //Looks for single or multiple taps and hides keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handle the action when the user presses the Search button
    // Makes the API call and modifies the table view
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
                    
                    for (key, subJson):(String, JSON) in jsonResponse["products"] {
                        let itemName = subJson["name"].string
                        let itemUrl = subJson["clickUrl"].string?.replacingOccurrences(of: "\\/", with: "/")
                        let description = subJson["description"].string
                        let picUrl =  subJson["image"]["sizes"]["IPhone"]["url"].string?.replacingOccurrences(of: "\\/", with: "/")
                        
                        
                        self.clothingSearchResults.append( ClothingItem(name: itemName!, brand: description!, itemUrl: itemUrl!) )
                        self.downloadImageFromUrl(url: picUrl!, index: Int(key)!)
                        
                    }
                    
                } else {
                    print(error!.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.tableviewResults.reloadData()
                    self.loadingAnimationView.stopAnimating()
                }
                
            })
            task.resume()
        } else {
            loadingAnimationView.stopAnimating()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ClothingItemTableViewCell
        
        cell.labelInfo.text = clothingSearchResults[indexPath.row].name
        cell.labelLink.text = clothingSearchResults[indexPath.row].itemUrl
        let clothingPic = clothingSearchResults[indexPath.row].itemImage == nil ? UIImage(named: "Placeholder") : clothingSearchResults[indexPath.row].itemImage!
        cell.imageViewClothingPic.image = clothingPic
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    // What to do when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: self.aroundMeToOtherUser, sender: nearbyUsers[indexPath.section])
    }
    
    func downloadImageFromUrl(url: String, index: Int) {
        
        let clothingPictureURL = URL(string:url)
        let session = URLSession(configuration: .default)
        let downloadTask = session.dataTask(with: clothingPictureURL!) { (data, response, error) in
            if error == nil {
                if let res = response as? HTTPURLResponse {
                    print("Download image with response code \(res.statusCode)")
                    if let imageData = data {
                        self.clothingSearchResults[index].itemImage = UIImage(data: imageData)
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Error downloading image")
            }
        }
        downloadTask.resume()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
