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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes the profile picture button circular
        imageViewProfilePicture.contentMode = .scaleAspectFill
        imageViewProfilePicture.layer.cornerRadius = 0.5 * imageViewProfilePicture.bounds.size.width
        imageViewProfilePicture.clipsToBounds = true
        
        userRef = FIRDatabase.database().reference(withPath: "users/" + otherUser.uid)
        userStorageRef = FIRStorage.storage().reference(withPath: "images/" + otherUser.uid)
        
        loadProfilePicture()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     Pulls the user's profile picture from the database if it exists
     */
    func loadProfilePicture() {
        // Load the stored image
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            let pictureOrientation = storedData?["profilePictureOrientation"] as? String ?? ""
            let firstName = storedData?["firstName"] as? String ?? ""
            let lastName = storedData?["lastName"] as? String ?? ""
            
            self.labelName.text = firstName + " " + lastName
            
            // Load profile picture if it exists
            if snapshot.hasChild("profilePictureUrl") {
                self.userStorageRef.child("ProfilePicture").data(withMaxSize: 20*1024*1024, completion: {(data, error) in
                    var profilePicture = UIImage(data:data!)
                    
                    // Be sure the picture has the correct orientation when it loads
                    if(profilePicture?.size.width.isLess(than: (profilePicture?.size.height)!))! {
                        if (pictureOrientation == "landscape") {
                            profilePicture = profilePicture?.rotated(by: Measurement(value: -90.0, unit: .degrees))
                        }
                    } else {
                        if (pictureOrientation == "portrait") {
                            profilePicture = profilePicture?.rotated(by: Measurement(value: 90.0, unit: .degrees))
                        }
                    }
                    
                    self.imageViewProfilePicture.image = profilePicture
                    self.imageViewProfilePicture.contentMode = .scaleAspectFill
                })
            } else {
                print("blah")
            }
        })
    }
    
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
