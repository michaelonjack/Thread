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
    
    let logoutToLogin = "LogoutToLogin"
    let locationManager = CLLocationManager()
    let currentUserRef = FIRDatabase.database().reference(withPath: "users/" + (FIRAuth.auth()?.currentUser?.uid)!)

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
    
    @IBAction func meDidTouch(_ sender: AnyObject) {
        
    }

    @IBAction func aroundMeDidTouch(_ sender: AnyObject) {
        
    }
    
    // Logs the user out and brings them back to the login page
    @IBAction func logOutDidTouch(_ sender: AnyObject) {
        do {
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: self.logoutToLogin, sender: nil)
        } catch {
            print("Error while signing out")
        }
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
