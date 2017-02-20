//
//  MainViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/16/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    // Name of segue used when the user selects the logout button (goes back to the login screen)
    let logoutToLogin = "LogoutToLogin"
    // LocationManager instance used to update the current user's location
    let locationManager = CLLocationManager()
    // Reference to the current user's information in the database
    let currentUserRef = FIRDatabase.database().reference(withPath: "users/" + (FIRAuth.auth()?.currentUser?.uid)!)

    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Requests the user's locations
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        // Request location authorization for the app
        self.locationManager.requestWhenInUseAuthorization()
        // Request a location update
        self.locationManager.requestLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  locationManager
    //
    //  Updates the user's latitude and longitude values in the Firebase database
    //  Implicitly called by viewDidLoad when requesting the location
    //
    // Process the received location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Grab latitude and longitude
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        // Update the user's location in the database
        currentUserRef.updateChildValues(["latitude": locValue.latitude, "longitude": locValue.longitude])
    }
    // Process any errors that may occur when gathering location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  logOutDidTouch
    //
    //  Handles when the log out button is pressed
    //  Logs the user out and brings them back to the login page
    //
    @IBAction func logOutDidTouch(_ sender: AnyObject) {
        do {
            try FIRAuth.auth()?.signOut()
            
            // Blank out the user's location
            currentUserRef.updateChildValues(["latitude": 0.0, "longitude": 0.0])
            
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Error while signing out")
        }
    }
    
    

}
