//
//  AroundMeTableViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/18/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//
//
//
//
// Around Me View Controller
//      -Table view that lists all Thread users that are in a 2 mile radius of you
//      -Clicking on a user in the table segues you to that user's profile
//      -Pulling down on the table view reloads your current location and refreshes the table view

import UIKit
import CoreLocation

class AroundMeTableViewController: UITableViewController, CLLocationManagerDelegate {

    // Maximum number of meters another user can be away and still show up in the table (roughly 2 miles)
    let MAX_ALLOWABLE_DISTANCE = 3000.0
    // Name of the segue that's used when the current user selects another user in the table
    let aroundMeToOtherUser = "aroundMeToOtherUser"
    
    // Reference to the app's users data in the Firebase database
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    // FIRUser instance that represents the current user
    let currentFIRUser = FIRAuth.auth()?.currentUser
    // LocationManager instance used to update the current user's location
    let locationManager = CLLocationManager()
    
    // Array of app users -- the data source of the table
    var nearbyUsers: [User] = []
    // Table refresher used to implement the pull-down-to-refresh functionality in the table view
    var refresher: UIRefreshControl!
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Listens for changes to the Users database and refreshes the table when the data is altered
    //
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

    
    
    /////////////////////////////////////////////////////
    //
    //  tableView - numberOfRowsInSection
    //
    //  Returns the number of rows in the table (uses the nearbyUsers array)
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyUsers.count
    }
    
   
    
    /////////////////////////////////////////////////////
    //
    //  tableView - willDisplay
    //
    //  Sets the background color of the table to match the color of other view controllers (Mocha)
    //
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = ((indexPath.row % 2) == 0) ? UIColor.init(red: 147.0/255.0, green: 82.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor.white
    }

    
    
    /////////////////////////////////////////////////////
    //
    //  tableView - cellForRowAt
    //
    //  Determines what information is to be displayed in each table cell
    //  Uses the User at the matching index of nearbyUsers to set the cell text to the user's name and the cell subtitle to their email
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = nearbyUsers[indexPath.row]
        
        cell.textLabel?.text = user.firstName + " " + user.lastName
        cell.detailTextLabel?.text = user.email

        return cell
    }

    
    
    //////////////////////////////////////////////////////
    //
    //  tableView - canEditRowAt
    //
    //  Determines if a table row can be edited -- For this table, no rows are editable
    //
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView - didSelectRowAt
    //
    //  Segues the selected user's profile view controller (OtherUserViewController)
    //
    // What to do when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: self.aroundMeToOtherUser, sender: nearbyUsers[indexPath.section])
    }

    
    
    /////////////////////////////////////////////////////
    //
    //  handleRefresh
    //
    //  Updates the current user's location when the table is refreshed
    //
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Request a location update
        refresher = refreshControl
        self.locationManager.requestLocation()
    }
    
    
    
    
    
    /////////////////////////////////////////////////////
    //
    //  locationManager
    //
    //  Processes the user's location update by saving the user's coordinates to the database
    //  Called implicitly by locationManager.requestWhenInUseAuthorization()
    //
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
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let otherUserVC: OtherUserViewController = segue.destination as! OtherUserViewController
        otherUserVC.otherUser = sender as! User
    }

}
