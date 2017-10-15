//
//  AccountViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/20/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var followingButtonTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var heartButtonTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var settingsButtonTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var profilePicTopSpacing: NSLayoutConstraint!
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    let currentUserStorageRef = Storage.storage().reference(withPath: "images/" + (Auth.auth().currentUser?.uid)!)
    
    
    
    /////////////////////////////////////////////////////
    //
    // viewDidLoad
    //
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust constraints for screen size
        followingButtonTopSpacing.constant = 63 * (UIScreen.main.bounds.height/667)
        heartButtonTopSpacing.constant = 63 * (UIScreen.main.bounds.height/667)
        settingsButtonTopSpacing.constant = 63 * (UIScreen.main.bounds.height/667)
        profilePicTopSpacing.constant = 45 * (UIScreen.main.bounds.height/667)

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Determines how blurred the view is
        blurEffectView.alpha = 0.9
        // Places the blur view behind the other UI components
        self.view.insertSubview(blurEffectView, at: 0)
        
        
        let swipeToDismiss = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUpAction(_:)))
        swipeToDismiss.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeToDismiss)
        
        
        self.imageViewProfilePicture.layer.cornerRadius = 8.0
        self.imageViewProfilePicture.clipsToBounds = true
        
        loadProfileData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // loadProfileData
    //
    //  Pulls the user's profile picture from the database if it exists
    //
    func loadProfileData() {
        // Load the stored image
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            let firstName = storedData?["firstName"] as? String ?? ""
            let lastName = storedData?["lastName"] as? String ?? ""
            let email = storedData?["email"] as? String ?? ""
            
            self.labelName.text = firstName + " " + lastName
            self.labelEmail.text = email
            
            // Load user's profile picture from Firebase Storage if it exists (exists if the user has a profPic URL in the database)
            if snapshot.hasChild("profilePictureUrl") {
                let picUrlStr = storedData?["profilePictureUrl"] as? String ?? ""
                if picUrlStr != "" {
                    let picUrl = URL(string: picUrlStr)
                    self.imageViewProfilePicture.sd_setImage(with: picUrl, placeholderImage: UIImage(named: "Avatar"))
                    self.imageViewProfilePicture.contentMode = .scaleAspectFill
                }
            } else {
                print("Error -- Loading Profile Picture")
            }
        })
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // followingDidTouch
    //
    // Segues the user to the table view containing all the users they're following
    //
    @IBAction func followingDidTouch(_ sender: Any) {
        
        if let presentingVC = self.presentingViewController as? MainViewController {
            presentingVC.performSegue(withIdentifier: "MainToFollowing", sender: nil)
        } else if let presentingVC = self.presentingViewController as? MeViewController {
            presentingVC.performSegue(withIdentifier: "MeToFollowing", sender: nil)
        } else if let presentingVC = self.presentingViewController as? MeAltViewController {
            presentingVC.performSegue(withIdentifier: "MeToFollowing", sender: nil)
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // favoritesDidTouch
    //
    // Segues the user to the table view containing all the clothes they've favorited
    //
    @IBAction func favoritesDidTouch(_ sender: Any) {
        
        if let presentingVC = self.presentingViewController as? MainViewController {
            presentingVC.performSegue(withIdentifier: "MainToFavorites", sender: nil)
        } else if let presentingVC = self.presentingViewController as? MeViewController {
            presentingVC.performSegue(withIdentifier: "MeToFavorites", sender: nil)
        } else if let presentingVC = self.presentingViewController as? MeAltViewController {
            presentingVC.performSegue(withIdentifier: "MeToFavorites", sender: nil)
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // settingsDidTouch
    //
    // Segues the user to the Settings view controller
    //
    @IBAction func settingsDidTouch(_ sender: Any) {
        if let presentingVC = self.presentingViewController as? MainViewController {
            presentingVC.performSegue(withIdentifier: "MainToSettings", sender: nil)
        } else if let presentingVC = self.presentingViewController as? MeViewController {
            presentingVC.performSegue(withIdentifier: "MeToSettings", sender: nil)
        } else if let presentingVC = self.presentingViewController as? MeAltViewController {
            presentingVC.performSegue(withIdentifier: "MeToSettings", sender: nil)
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // dismissDidTouch
    //
    // Performs same exact action as when user swipes up
    //
    @IBAction func dismissDidTouch(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    
    /////////////////////////////////////////////////////
    //
    // swipeUpAction
    //
    // Handles the action of the user swiping up on the screen
    // Dismisses the Account view controller and returns to the
    //
    @objc func swipeUpAction(_ gesture: UIGestureRecognizer) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    

}
