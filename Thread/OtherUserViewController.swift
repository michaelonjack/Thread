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
    
    var userRef: FIRDatabaseReference!
    var userStorageRef: FIRStorageReference!
    var otherUser: User!
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Shapes the user's profile picture into a circle
    //  Loads the user's profile picture into the view
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userRef = FIRDatabase.database().reference(withPath: "users/" + otherUser.uid)
        userStorageRef = FIRStorage.storage().reference(withPath: "images/" + otherUser.uid)
        
        loadProfilePicture()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        // Makes the profile picture button circular
        imageViewProfilePicture.contentMode = .scaleAspectFill
        imageViewProfilePicture.layer.cornerRadius = 0.5 * imageViewProfilePicture.layer.bounds.width
        imageViewProfilePicture.clipsToBounds = true
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
                self.userStorageRef.child("ProfilePicture").data(withMaxSize: 20*1024*1024, completion: {(data, error) in
                    if data != nil {
                        let profilePicture = UIImage(data:data!)
                        
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
                print("Error loading user image")
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
