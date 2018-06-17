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
    
    @IBOutlet weak var viewVerticalSpacing: NSLayoutConstraint!
    
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    
    var userRef: DatabaseReference!
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
        
        viewVerticalSpacing.constant = 26 * (UIScreen.main.bounds.height/667)
        
        userRef = Database.database().reference(withPath: "users/" + otherUser.uid)
        
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
        isFollowingUser(userid: self.otherUser.uid, completion: { (isFollowing) in
            if (isFollowing) {
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
                let picUrlStr = storedData?["profilePictureUrl"] as? String ?? ""
                if picUrlStr != "" {
                    let picUrl = URL(string: picUrlStr)
                    self.imageViewProfilePicture.sd_setImage(with: picUrl, placeholderImage: UIImage(named: "Avatar"))
                }
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
        userRef.child(named).observeSingleEvent(of: .value, with: { (snapshot) in
            let clothingData = snapshot.value as? NSDictionary
            
            // Check if the clothing item has a picture URL saved
            if snapshot.hasChild("pictureUrl") {
                
                // If so, use that URL to load the image using SDWebImage
                let picUrlStr = clothingData?["pictureUrl"] as? String ?? ""
                if picUrlStr != "" {
                    let picUrl = URL(string: picUrlStr)
                    print("here")
                    button.imageView?.contentMode = .scaleAspectFit
                    button.sd_setImage(with: picUrl, for: .normal)
                }
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
        
        isFollowingUser(userid: self.otherUser.uid, completion: { (isFollowing) in
            if isFollowing {
                unfollowUser(userid: self.otherUser.uid)
                DispatchQueue.main.async {
                    self.buttonFollowUser.setImage( UIImage(named: "Follow"), for: .normal )
                }
            } else {
                followUser(userid: self.otherUser.uid)
                DispatchQueue.main.async {
                    self.buttonFollowUser.setImage( UIImage(named: "Unfollow"), for: .normal )
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
