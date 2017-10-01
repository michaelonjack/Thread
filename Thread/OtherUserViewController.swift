//
//  OtherUserViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/29/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import FirebaseStorage

class OtherUserViewController: UIViewController {

    
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgButton: UIButton!
    @IBOutlet weak var buttonFollowUser: UIButton!
    
    @IBOutlet weak var shirtTopLayout: NSLayoutConstraint!
    @IBOutlet weak var bottomTopLayout: NSLayoutConstraint!
    @IBOutlet weak var shoesTopLayout: NSLayoutConstraint!
    @IBOutlet weak var accessoriesTopLayout: NSLayoutConstraint!
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    
    var userRef: DatabaseReference!
    var userStorageRef: StorageReference!
    var otherUser: User!
    var containerViewController: OtherUserContainerViewController?
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Shapes the user's profile picture into a circle
    //  Loads the user's profile picture into the view
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust constraints based on screen size
        shirtTopLayout.constant = 44 * (UIScreen.main.bounds.height/667)
        bottomTopLayout.constant = 44 * (UIScreen.main.bounds.height/667)
        shoesTopLayout.constant = 225 * (UIScreen.main.bounds.height/667)
        accessoriesTopLayout.constant = 225 * (UIScreen.main.bounds.height/667)
        
        userRef = Database.database().reference(withPath: "users/" + otherUser.uid)
        userStorageRef = Storage.storage().reference(withPath: "images/" + otherUser.uid)
        
        setFollowButton()
        loadProfilePicture()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    //  setFollowButton
    //
    //  Sets the follow button to the correct image depending on its state
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
    //  loadProfilePicture
    //
    //  Pulls the user's profile picture from the database if it exists and sets it as the imageView's image
    //
    func loadProfilePicture() {
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
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  switchViewDidTouch
    //
    //
    //
    @IBAction func switchViewDidTouch(_ sender: UIButton) {
        
        self.containerViewController?.cycle(from: self, to: (self.containerViewController?.imageViewController)!, direction: UIViewAnimationOptions.transitionFlipFromRight)
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
