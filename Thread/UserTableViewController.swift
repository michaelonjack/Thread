//
//  UserTableViewController.swift
//  Thread
//
//  Created by Michael Onjack on 6/24/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseStorage

class UserTableViewController: UITableViewController, UsersTableViewCellHeaderDelegate, CLLocationManagerDelegate {
    
    // Maximum number of meters another user can be away and still show up in the table (roughly 2 miles)
    let MAX_ALLOWABLE_DISTANCE = 3000.0
    // Name of the segue that's used when the current user selects another user in the table
    let aroundMeToOtherUser = "AroundMeToOtherUser"
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    
    // Reference to the app's users data in the Firebase database
    let usersRef = Database.database().reference(withPath: "users")
    // FIRUser instance that represents the current user
    let currentFIRUser = Auth.auth().currentUser
    // LocationManager instance used to update the current user's location
    let locationManager = CLLocationManager()
    
    var forAroundMe = true
    // Array of app users -- the data source of the table
    var displayUsers: [User] = []
    // Table refresher used to implement the pull-down-to-refresh functionality in the table view
    var refresher: UIRefreshControl!
    var currentUserCoordinates:CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 520
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
        ]
        
        // Determine how the User table view will be used
        if (forAroundMe == true) {
            self.title = "Around Me"
        } else {
            self.title = "Following"
        }
        
        self.locationManager.delegate = self
        // Request location authorization for the app
        self.locationManager.requestWhenInUseAuthorization()
        
        // If the table is meant to be used to display the nearby users, go through this control path
        if forAroundMe == true {
            
            // This will run every time the current user's latitude changes
            usersRef.child((currentFIRUser?.uid)! + "/latitude").observe(.value, with: { snapshot in
                
                DispatchQueue.main.async {
                    self.displayUsers.removeAll()
                }
                
                self.usersRef.observeSingleEvent(of: .value, with: { parentSnapshot in
                    // End refreshing the table once the user location is retrieved
                    if self.refresher != nil {
                        self.refresher.endRefreshing()
                    }
                    
                    // Iterate through the list of users
                    for user in parentSnapshot.children {
                        
                        // Create instance of the potentially nearby user
                        let nearbyUser = User(snapshot: user as! DataSnapshot)
                        
                        // Create a database snapshot for the currently logged in user
                        let currentUserSnapshot = parentSnapshot.childSnapshot(forPath: (self.currentFIRUser?.uid)!)
                        let currentUserSnapshotValue = currentUserSnapshot.value as! [String : AnyObject]
                        
                        // Get the currently logged in user's position using the database snapshot
                        let latitude = currentUserSnapshotValue["latitude"] as? Double
                        let longitude = currentUserSnapshotValue["longitude"] as? Double
                        
                        // If a user's longitude and latitude are set to 0.0 then their location is not known so show no nearby users
                        if( floor(latitude!) != 0 && floor(longitude!) != 0 ) {
                            
                            // Get the current user's location using their latitude and longitude
                            let currentUserLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                            // Get the potentially nearby user's location using their latitude and longitudde
                            let nearbyUserLocation = CLLocation(latitude: nearbyUser.latitude, longitude: nearbyUser.longitude)
                            
                            self.currentUserCoordinates = currentUserLocation.coordinate
                            
                            // Determine if user is near the current user, if so add to list
                            print("Distance between: " + String(currentUserLocation.distance(from: nearbyUserLocation)))
                            //if (currentUserLocation.distance(from: nearbyUserLocation) < self.MAX_ALLOWABLE_DISTANCE) {
                            self.displayUsers.append(nearbyUser)
                            //}
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                })
            })
        }
            
            // If the table is meant to be used to display the followed users, go through this control path
        else {
            // Get the list of users that the current user follows
            usersRef.child((currentFIRUser?.uid)! + "/Following").observe(.value, with: { followedUsersSnapshot in
                
                // Remove all the users from the list before continuing (this gets called every time a user
                // is followed or unfollowed so there would be duplicate rows if we didn't delete)
                DispatchQueue.main.async {
                    self.displayUsers.removeAll()
                }
                
                self.usersRef.observeSingleEvent(of: .value, with: { usersSnapshot in
                    
                    for user in followedUsersSnapshot.children {
                        let userSnapshot = user as! DataSnapshot
                        let userId = userSnapshot.key
                        
                        // Check to be sure the followed user still exists in the system
                        if usersSnapshot.hasChild(userId) {
                            let followedUser = User(snapshot: usersSnapshot.childSnapshot(forPath: userId))
                            self.displayUsers.append(followedUser)
                        }
                            
                            // If the user no longer exists, remove it from the Following list
                        else {
                            self.usersRef.child((self.currentFIRUser?.uid)! + "/Following/" + userId).removeValue()
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            })
        }
        
        
        // Enable pull down to refresh
        self.refreshControl?.addTarget(self, action: #selector(AroundMeTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    /////////////////////////////////////////////////////
    //
    //  tableView - numberOfRowsInSection
    //
    //  Returns the number of rows in the table (uses the displayUsers array)
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayUsers.count
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView - willDisplay
    //
    //  Sets the background color of the table to match the color of other view controllers (Mocha)
    //
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        cell.contentView.backgroundColor = UIColor.init(red: 147.0/255.0, green: 82.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Grab first view from the nib file
        let headerView = Bundle.main.loadNibNamed("UsersTableViewCellHeader", owner: self, options: nil)?.first as! UsersTableViewCellHeader
        
        headerView.delegate = self
        
        if forAroundMe {
            headerView.titleLabel.text = "Around Me"
            headerView.dismissButton.isHidden = true
        } else {
            headerView.titleLabel.text = "Following"
            headerView.dismissButton.isHidden = false
        }
        
        return headerView
    }
    func dismissTable() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if forAroundMe {
            return "AROUND ME"
        } else {
            return "FOLLOWING"
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView - cellForRowAt
    //
    //  Determines what information is to be displayed in each table cell
    //  Uses the User at the matching index of displayUsers to set the cell text to the user's name and the cell subtitle to their email
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user = displayUsers[indexPath.row]
        
        // Reset the cell
        cell.imageViewProfilePicture.image = UIImage(named: "Avatar")
        cell.imageViewOutfitPicture.image = UIImage(named: "PlaceholderIcon")
        cell.buttonFollow.setImage( UIImage(named: "Follow"), for: .normal )
        cell.labelUserName.text = user.firstName + " " + user.lastName
        
        // Determine if the current user is following the user in this cell
        setFollowButtonForUser(userid: user.uid, followButton: cell.buttonFollow)
        
        // Load the user's profile picture asynchronously
        if user.profilePictureUrl != nil && user.profilePictureUrl != "" {
            
            let picUrlStr = user.profilePictureUrl!
            
            let picUrl = URL(string: picUrlStr)
            
            cell.imageViewProfilePicture.sd_setImage(with: picUrl, placeholderImage: UIImage(named: "Avatar"))
            
        } else {
            cell.imageViewProfilePicture.image = UIImage(named: "Avatar")
        }
        
        // Load the user's outfit picture asynchronously
        if user.outfitPictureUrl != nil && user.outfitPictureUrl != "" {
            
            let picUrlStr = user.outfitPictureUrl!
            let picUrl = URL(string: picUrlStr)
            
            cell.imageViewOutfitPicture.sd_setImage(with: picUrl, placeholderImage: UIImage(named: "PlaceholderIcon"))
        }
        
        
        getDataForUser(userid: user.uid, completion: { (userData) in
            let status = userData["status"] as? String ?? ""
            let lastCheckIn = userData["lastCheckIn"] as? String ?? ""
            let city = userData["location"]?["city"] as? String ?? ""
            let state = userData["location"]?["state"] as? String ?? ""
            let locationStr = city + ", " + state == ", " ? "Hiding :)" : city + ", " + state
            
            DispatchQueue.main.async {
                cell.labelUserLocation.text = locationStr
                cell.labelCheckIn.text = "Last checked in " + self.getTimeElapsed(dateStr: lastCheckIn)
                cell.labelStatus.text = status == "" ? "No status" : status
            }
        })
        
        // Makes the profile picture view circular
        cell.imageViewProfilePicture.contentMode = .scaleAspectFill
        cell.imageViewProfilePicture.layer.cornerRadius = 0.5 * cell.imageViewProfilePicture.layer.bounds.width
        cell.imageViewProfilePicture.clipsToBounds = true
        
        return cell
    }
    
    
    
    //////////////////////////////////////////////////////
    //
    //  tableView - canEditRowAt
    //
    //  Determines if a table row can be edited -- For this table, no rows are editable
    //
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if forAroundMe {
            return false
        } else {
            return true
        }
    }
    
    
    
    //////////////////////////////////////////////////////
    //
    //
    //
    //
    //
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.currentUserRef.child("Following/" + displayUsers[indexPath.row].uid).removeValue()
            
            tableView.reloadData()
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView - didSelectRowAt
    //
    //  Segues the selected user's profile view controller (OtherUserViewController)
    //
    // What to do when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: self.aroundMeToOtherUser, sender: displayUsers[indexPath.row])
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
        
        if forAroundMe == true {
            self.locationManager.requestLocation()
        } else {
            refreshControl.endRefreshing()
        }
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
        
        // Update the user's location in the database if it has changed
        if self.currentUserCoordinates != nil
            && self.currentUserCoordinates?.latitude == locValue.latitude
            && self.currentUserCoordinates?.longitude == locValue.longitude {
            
            if self.refresher != nil {
                self.refresher.endRefreshing()
            }
        } else {
            currentUserRef.updateChildValues(["latitude": locValue.latitude, "longitude": locValue.longitude])
        }
    }
    // Process any errors that may occur when gathering location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
    
    /////////////////////////////////////////////////////
    //
    //  followUserDidTouch
    //
    //
    //
    @IBAction func followUserDidTouch(_ sender: UIButton) {
        // Get the cell the button comes from
        guard let cell = sender.superview?.superview as? UserTableViewCell else {
            print("error happened or something")
            return 
        }
        let indexPath = self.tableView.indexPath(for: cell)
        let user = displayUsers[(indexPath?.row)!]
        
        isFollowingUser(userid: user.uid, completion: { (isFollowing) in
            if isFollowing {
                unfollowUser(userid: user.uid)
                DispatchQueue.main.async {
                    sender.setImage( UIImage(named: "Follow"), for: .normal )
                }
            } else {
                followUser(userid: user.uid)
                DispatchQueue.main.async {
                    sender.setImage( UIImage(named: "Unfollow"), for: .normal )
                }
            }
        })
    }
    
    
    
    
    /////////////////////////////////////////////////////
    //
    //  setFollowButton
    //
    //  Sets the follow button to the correct image depending on its state
    //
    func setFollowButtonForUser(userid:String, followButton: UIButton) {
        
        isFollowingUser(userid: userid, completion: { (isFollowing) in
            if (isFollowing) {
                DispatchQueue.main.async {
                    followButton.setImage(UIImage(named: "Unfollow"), for: .normal)
                }
            }
        })

    }
    
    
    
    
    /////////////////////////////////////////////////////
    //
    //  getTimeElapsed
    //
    //
    //
    func getTimeElapsed(dateStr: String) -> String {
        
        var timeElapsedStr = ""
        
        if dateStr != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy HH:mm"
            
            let d = formatter.date(from: dateStr)
            if let date = d {
                let secondsSince = Int(Date().timeIntervalSince(date))
                let minutesSince = secondsSince / 60
                let hoursSince = minutesSince / 60
                let daysSince = hoursSince / 24
                
                if secondsSince / 60 == 0 {
                    timeElapsedStr = String(secondsSince) + " seconds ago"
                } else if minutesSince / 60 == 0 {
                    timeElapsedStr = String(minutesSince) + " minutes ago"
                } else if hoursSince / 24 == 0 {
                    timeElapsedStr = String(hoursSince) + " hours ago"
                } else {
                    timeElapsedStr = String(daysSince) + " days ago"
                }
            }
        }
        return timeElapsedStr
    }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? OtherUserContainerViewController {
            let otherUserVC: OtherUserContainerViewController = segue.destination as! OtherUserContainerViewController
            otherUserVC.otherUser = sender as! User
        }
        
        else if let _ = segue.destination as? UINavigationController {
            let otherUserNavigationVC: UINavigationController = segue.destination as! UINavigationController
            let otherUserVC: OtherUserContainerViewController = otherUserNavigationVC.viewControllers.first as! OtherUserContainerViewController
            otherUserVC.otherUser = sender as! User
        }
    }

}
