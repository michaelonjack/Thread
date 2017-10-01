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
    let mainToAccount = "MainToAccount"
    // LocationManager instance used to update the current user's location
    let locationManager = CLLocationManager()
    // Reference to the current user's information in the database
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)

    @IBOutlet weak var meTopLayout: NSLayoutConstraint!
    @IBOutlet weak var aroundMeTopLayout: NSLayoutConstraint!
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Requests the user's locations
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meTopLayout.constant = 84.5 * (UIScreen.main.bounds.height/667)
        aroundMeTopLayout.constant = 19 * (UIScreen.main.bounds.height/667)
        
        let swipeToShowAccount = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
        swipeToShowAccount.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeToShowAccount)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func swipeDown(_ gesture: UIGestureRecognizer) {
        self.performSegue(withIdentifier: mainToAccount, sender: nil)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  prepareForSegue
    //
    //
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToFollowing" {
            let followingVC: UserTableViewController = segue.destination as! UserTableViewController
            followingVC.forAroundMe = false
        }
    }

}
