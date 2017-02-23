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
    
    let currentUserRef = FIRDatabase.database().reference(withPath: "users/" + (FIRAuth.auth()?.currentUser?.uid)!)
    let currentUserStorageRef = FIRStorage.storage().reference(withPath: "images/" + (FIRAuth.auth()?.currentUser?.uid)!)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    // loadProfilePicture
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
                self.currentUserStorageRef.child("ProfilePicture").data(withMaxSize: 20*1024*1024, completion: {(data, error) in
                    if data != nil {
                        let profilePicture = UIImage(data:data!)
                    
                        // Sets the user's profile picture to the loaded image
                        self.imageViewProfilePicture.image = profilePicture
                        self.imageViewProfilePicture.contentMode = .scaleAspectFill
                    } else {
                        let errorAlert = UIAlertController(title: "Uh oh!",
                                                           message: "Unable to retrieve information.",
                                                           preferredStyle: .alert)
                        
                        let closeAction = UIAlertAction(title: "Close", style: .default)
                        errorAlert.addAction(closeAction)
                        self.present(errorAlert, animated: true, completion:nil)
                    }
                })
            } else {
                print("Error -- Loading Profile Picture")
            }
        })
    }
    
    
    
    func swipeUpAction(_ gesture: UIGestureRecognizer) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }

}
