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
        
        let query = textFieldQuery.text
        if query != nil && query != "" {
            
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
                    print(jsonResponse.rawString() ?? "Error with swifty")
                    
                } else {
                    print(error!.localizedDescription)
                }
            })
            self.loadingAnimationView.stopAnimating()
            task.resume()
        } else {
            loadingAnimationView.stopAnimating()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        cell.textLabel?.text = clothingSearchResults[indexPath.row].name
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
