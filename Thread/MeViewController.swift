//
//  MeViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/17/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//
//
//
//
// Me View Controller
//      -View that represents the current user's "profile"
//      -Users can navigate to and edit their different clothing options from this view
//      -Users can update their profile picture from this view by pressing their profile picture

import UIKit
import FirebaseStorage
import SDWebImage
import YPImagePicker

class MeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var buttonProfilePicture: UIButton!
    @IBOutlet weak var labelGreeting: UILabel!
    
    @IBOutlet weak var shirtTopLayout: NSLayoutConstraint!
    @IBOutlet weak var bottomTopLayout: NSLayoutConstraint!
    @IBOutlet weak var shoesTopLayout: NSLayoutConstraint!
    @IBOutlet weak var accessoriesTopLayout: NSLayoutConstraint!
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    let currentUserStorageRef = Storage.storage().reference(withPath: "images/" + (Auth.auth().currentUser?.uid)!)
    
    var containerViewController: MeContainerViewController?
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Shapes the user's profile picture into a circle and loads it from storage
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust constraints based on screen size
        shirtTopLayout.constant = 44 * (UIScreen.main.bounds.height/667)
        bottomTopLayout.constant = 44 * (UIScreen.main.bounds.height/667)
        shoesTopLayout.constant = 225 * (UIScreen.main.bounds.height/667)
        accessoriesTopLayout.constant = 225 * (UIScreen.main.bounds.height/667)

        // Makes the profile picture button circular
        buttonProfilePicture.imageView?.contentMode = .scaleAspectFill
        buttonProfilePicture.layer.cornerRadius = 0.5 * buttonProfilePicture.bounds.size.width
        buttonProfilePicture.clipsToBounds = true
        
        // Loads the user's profile picture from the database
        loadProfilePicture()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  profilePictureDidTouch
    //
    //  Handles the action when the profile picture button is pressed.
    //  Launches the user's camera so they can take a new picture and then saves that image to the database
    //
    @IBAction func profilePictureDidTouch(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            var ypConfig = YPImagePickerConfiguration()
            ypConfig.onlySquareImagesFromCamera = true
            ypConfig.library.onlySquare = true
            ypConfig.showsFilters = true
            ypConfig.library.mediaType = .photo
            ypConfig.usesFrontCamera = false
            ypConfig.shouldSaveNewPicturesToAlbum = false
            
            let picker = YPImagePicker(configuration: ypConfig)
            picker.didFinishPicking { items, _ in
                if let image = items.singlePhoto {
                    // Sets the user's profile picture to be this image
                    self.buttonProfilePicture.setImage(image.image, for: .normal)
                    self.buttonProfilePicture.imageView?.contentMode = .scaleAspectFill
                    
                    uploadProfilePictureForUser(userid: (Auth.auth().currentUser?.uid)!, image: image.image)
                    
                    picker.dismiss(animated: true, completion: nil)
                }
            }
            present(picker, animated: true, completion: nil)
        } else {
            print("Error -- Camera")
        }
    }

    

    /////////////////////////////////////////////////////
    //
    // loadProfilePicture
    //
    //  Pulls the user's profile picture from the database if it exists
    //
    func loadProfilePicture() {
        // Load the stored image
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            let firstName = storedData?["firstName"] as? String ?? ""
            
            // Set the view's greeting label
            self.labelGreeting.text = "Hi, " + firstName
            
            // Load user's profile picture from Firebase Storage if it exists (exists if the user has a profPic URL in the database)
            if snapshot.hasChild("profilePictureUrl") {
                let picUrlStr = storedData?["profilePictureUrl"] as? String ?? ""
                if picUrlStr != "" {
                    let picUrl = URL(string: picUrlStr)
                    self.buttonProfilePicture.sd_setImage(with: picUrl, for: .normal, placeholderImage: UIImage(named: "Avatar"))
                }
            } else {
                print("Error -- Loading Profile Picture")
            }
        })
    }
    
    
    
    @IBAction func switchViewDidTouch(_ sender: UIButton) {
        
        self.containerViewController?.cycle(from: self, to: (self.containerViewController?.imageViewController)!, direction: UIViewAnimationOptions.transitionFlipFromRight)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  prepareForSegue
    //
    //  Segues to the selected ClothingItem view controller (could be Top, Bottom, Shoes, Accessories depending on which button was pressed)
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "topToClothingItem":
                let topVC: ClothingItemViewController = segue.destination as! ClothingItemViewController
                topVC.clothingType = ClothingType.Top
            case "bottomToClothingItem":
                let bottomVC:ClothingItemViewController = segue.destination as! ClothingItemViewController
                bottomVC.clothingType = ClothingType.Bottom
            case "shoeToClothingItem":
                let shoeVC:ClothingItemViewController = segue.destination as! ClothingItemViewController
                shoeVC.clothingType = ClothingType.Shoes
            case "accessoryToClothingItem":
                let accessoryVC:ClothingItemViewController = segue.destination as! ClothingItemViewController
                accessoryVC.clothingType = ClothingType.Accessories
            case "MeToFollowing":
                let followingVC: UserTableViewController = segue.destination as! UserTableViewController
                followingVC.forAroundMe = false
            default:
                var _ = 0
        }
    }

}


