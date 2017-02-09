//
//  AroundMeTableViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/18/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import CoreLocation

class AroundMeTableViewController: UITableViewController, CLLocationManagerDelegate {

    // Maximum number of meters another user can be away and show up on the app
    let MAX_ALLOWABLE_DISTANCE = 3000.0
    let aroundMeToOtherUser = "aroundMeToOtherUser"
    
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let currentFIRUser = FIRAuth.auth()?.currentUser
    let locationManager = CLLocationManager()
    
    var nearbyUsers: [User] = []
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Give table VC mocha colored background
        self.tableView.backgroundColor = UIColor.init(red: 147.0/255.0, green: 82.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        
        
        self.locationManager.delegate = self
        // Request location authorization for the app
        self.locationManager.requestWhenInUseAuthorization()
        
        
        
        // This listens for a .value event type which in turn listens for different types of changes to the database (add, remove, update)
        // The app is notified of the change via the second parameter closure 
        // The snapshot represents the data at the moment in time
        usersRef.observe(.value, with: { snapshot in
            var nearestUsers: [User] = []
            
            // End refreshing the table once the user location is retrieved
            if self.refresher != nil {
                self.refresher.endRefreshing()
            }
            
            // Iterate through the list of users
            for user in snapshot.children {
                // Create instance of the potentially nearby user
                let nearbyUser = User(snapshot: user as! FIRDataSnapshot)
                print(nearbyUser)
                
                // Create a database snapshot for the currently logged in user
                let currentUserSnapshot = snapshot.childSnapshot(forPath: (self.currentFIRUser?.uid)!)
                let currentUserSnapshotValue = currentUserSnapshot.value as! [String : AnyObject]
                
                // Get the currently logged in user's position using the database snapshot
                let latitude = currentUserSnapshotValue["latitude"] as? Double
                let longitude = currentUserSnapshotValue["longitude"] as? Double
                print("latitude: " + String(describing: latitude))
                print("longitude: " + String(describing: longitude))
                
                // Get the current user's location using their latitude and longitude
                let currentUserLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                // Get the potentially nearby user's location using their latitude and longitudde
                let nearbyUserLocation = CLLocation(latitude: nearbyUser.latitude, longitude: nearbyUser.longitude)
                
                // Determine if user is near the current user, if so add to list
                print("Distance between: " + String(currentUserLocation.distance(from: nearbyUserLocation)))
                if (currentUserLocation.distance(from: nearbyUserLocation) < self.MAX_ALLOWABLE_DISTANCE) {
                    nearestUsers.append(nearbyUser)
                }
                
                // If a user's longitude and latitude are set to 0.0 then their location is not known so show no nearby users
                if( floor(latitude!)==0 && floor(longitude!)==0 ) {
                    nearestUsers.removeAll()
                }
                
            }
            
            self.nearbyUsers = nearestUsers
            self.tableView.reloadData()
        })
        
        
        
        // Enable pull down to refresh
        self.refreshControl?.addTarget(self, action: #selector(AroundMeTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    
    
    // Return number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyUsers.count
    }
    
   
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = ((indexPath.row % 2) == 0) ? UIColor.init(red: 147.0/255.0, green: 82.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor.white
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = nearbyUsers[indexPath.row]
        
        cell.textLabel?.text = user.firstName + " " + user.lastName
        cell.detailTextLabel?.text = user.email

        return cell
    }

    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    
    // What to do when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: self.aroundMeToOtherUser, sender: nearbyUsers[indexPath.section])
    }

    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Request a location update
        refresher = refreshControl
        self.locationManager.requestLocation()
    }
    
    
    
    // Process the received location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Grab latitude and longitude
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        // Update the user's location in the database
        usersRef.child((currentFIRUser?.uid)!).updateChildValues(["latitude": locValue.latitude, "longitude": locValue.longitude])
    }
    
    // Process any errors that may occur when gathering location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let otherUserVC: OtherUserViewController = segue.destination as! OtherUserViewController
        otherUserVC.otherUser = sender as! User
    }

}
