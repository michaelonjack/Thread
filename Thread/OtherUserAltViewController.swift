//
//  OtherUserAltViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/26/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class OtherUserAltViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var buttonTop: UIButton!
    @IBOutlet weak var buttonBottom: UIButton!
    @IBOutlet weak var buttonShoes: UIButton!
    @IBOutlet weak var buttonAccessories: UIButton!
    @IBOutlet weak var buttonFollowUser: UIButton!
    
    let currentUserRef = FIRDatabase.database().reference(withPath: "users/" + (FIRAuth.auth()?.currentUser?.uid)!)
    
    var userRef: FIRDatabaseReference!
    var userStorageRef: FIRStorageReference!
    var otherUser: User!
    var containerViewController: OtherUserContainerViewController?
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Shapes the user's profile picture into a circle
    //  Loads the user's pictures into the view
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userRef = FIRDatabase.database().reference(withPath: "users/" + otherUser.uid)
        userStorageRef = FIRStorage.storage().reference(withPath: "images/" + otherUser.uid)
        
        setFollowButton()
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        // Makes the profile picture button circular
        if imageViewProfilePicture != nil {
            imageViewProfilePicture.contentMode = .scaleAspectFill
            imageViewProfilePicture.layer.cornerRadius = 0.5 * imageViewProfilePicture.layer.bounds.width
            imageViewProfilePicture.clipsToBounds = true
        }
    }
    
    
    /////////////////////////////////////////////////////
    //
    //  isFollowing
    //
    //  Returns true if the current user is following this user
    //
    func setFollowButton() {
        currentUserRef.child("Following").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.otherUser.uid) {
                DispatchQueue.main.async {
                    self.buttonFollowUser.setImage(UIImage(named: "Unfollow"), for: .normal)
                }
            }
        })
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  loadData
    //
    //  Pulls the user's info from the database and sets them in the view
    //
    func loadData() {
        // Load the stored image
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            let firstName = storedData?["firstName"] as? String ?? ""
            let lastName = storedData?["lastName"] as? String ?? ""
            
            self.labelName.text = firstName + " " + lastName
            
            // Load profile picture if it exists
            if snapshot.hasChild("profilePictureUrl") {
                self.userStorageRef.child("ProfilePicture").data(withMaxSize: 20*1024*1024, completion: {(data, error) in
                    if data != nil {
                        let profilePicture = UIImage(data:data!)
                        
                        self.imageViewProfilePicture.image = profilePicture
                        self.imageViewProfilePicture.contentMode = .scaleAspectFill
                    }
                })
            } else {
                print("Error loading user image")
            }
        })
        
        loadImage(named: "Top", button: self.buttonTop)
        loadImage(named: "Bottom", button: self.buttonBottom)
        loadImage(named: "Shoes", button: self.buttonShoes)
        loadImage(named: "Accessories", button: self.buttonAccessories)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  loadImage
    //
    //  Loads the image specified by the 'name' parameter into the button specified by the 'button' parameter
    //
    func loadImage(named: String, button: UIButton) {
        self.userStorageRef.child(named).data(withMaxSize: 20*1024*1024, completion: {(data, error) in
            if data != nil {
                let topPicture = UIImage(data:data!)
                
                button.imageView?.contentMode = .scaleAspectFit
                button.setImage(topPicture, for: .normal)
            }
        })
    }

    
    
    /////////////////////////////////////////////////////
    //
    //  switchViewDidTouch
    //
    //
    //
    @IBAction func switchViewDidTouch(_ sender: Any) {
        self.containerViewController?.cycle(from: self, to: (self.containerViewController?.iconViewController)!, direction: UIViewAnimationOptions.transitionFlipFromLeft)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  followUserDidTouch
    //
    //
    //
    @IBAction func followUserDidTouch(_ sender: Any) {
        currentUserRef.child("Following").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Add the user to their Following list if they are following less than 6 users and have not already
            //      added this user
            if snapshot.childrenCount < 6 && !snapshot.hasChild(self.otherUser.uid) {
                self.currentUserRef.child("Following").updateChildValues( [self.otherUser.uid : true] )
                
                DispatchQueue.main.async {
                    self.buttonFollowUser.setImage( UIImage(named: "Unfollow"), for: .normal )
                }
                
            } else if snapshot.childrenCount == 6 {
                
            } else if snapshot.hasChild(self.otherUser.uid) {
                
                self.currentUserRef.child("Following/" + self.otherUser.uid).removeValue()
                
                DispatchQueue.main.async {
                    self.buttonFollowUser.setImage( UIImage(named: "Follow"), for: .normal )
                }
                
            }
        })
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  prepareForSegue
    //
    //  Segues to the other user's selected clothing type
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "TopToClothingItem":
            let topVC: OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            topVC.clothingType = ClothingType.Top
            topVC.user = otherUser
        case "BottomToClothingItem":
            let bottomVC:OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            bottomVC.clothingType = ClothingType.Bottom
            bottomVC.user = otherUser
        case "ShoeToClothingItem":
            let shoeVC:OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            shoeVC.clothingType = ClothingType.Shoes
            shoeVC.user = otherUser
        case "AccessoryToClothingItem":
            let accessoryVC:OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            accessoryVC.clothingType = ClothingType.Accessories
            accessoryVC.user = otherUser
        default:
            let defaultVC:OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            defaultVC.clothingType = nil
            defaultVC.user = nil
        }
    }
    
}
