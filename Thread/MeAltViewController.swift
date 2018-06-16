//
//  MeAltViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/27/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import YPImagePicker

class MeAltViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var buttonProfilePicture: UIButton!
    @IBOutlet weak var labelGreeting: UILabel!
    @IBOutlet weak var buttonTop: UIButton!
    @IBOutlet weak var buttonBottom: UIButton!
    @IBOutlet weak var buttonShoes: UIButton!
    @IBOutlet weak var buttonAccessories: UIButton!
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    let currentUserStorageRef = Storage.storage().reference(withPath: "images/" + (Auth.auth().currentUser?.uid)!)
    
    var containerViewController: MeContainerViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes the profile picture button circular
        buttonProfilePicture.imageView?.contentMode = .scaleAspectFill
        buttonProfilePicture.layer.cornerRadius = 0.5 * buttonProfilePicture.bounds.size.width
        buttonProfilePicture.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
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
        
        var ypConfig = YPImagePickerConfiguration()
        ypConfig.onlySquareImagesFromCamera = true
        ypConfig.library.onlySquare = true
        ypConfig.showsFilters = true
        ypConfig.library.mediaType = .photo
        ypConfig.usesFrontCamera = false
        ypConfig.shouldSaveNewPicturesToAlbum = false
        
        let picker = YPImagePicker(configuration: ypConfig)
        picker.didFinishPicking { items, _ in
            if let photo = items.singlePhoto {
                // Sets the user's profile picture to be this image
                self.buttonProfilePicture.setImage(photo.image, for: .normal)
                self.buttonProfilePicture.imageView?.contentMode = .scaleAspectFill
                
                uploadProfilePictureForUser(userid: (Auth.auth().currentUser?.uid)!, image: photo.image)
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // loadData
    //
    //  
    //
    func loadData() {
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
        currentUserRef.child(named).observeSingleEvent(of: .value, with: { (snapshot) in
            let clothingData = snapshot.value as? NSDictionary
            
            // Check if the clothing item has a picture URL saved
            if snapshot.hasChild("pictureUrl") {
                
                // If so, use that URL to load the image using SDWebImage
                let picUrlStr = clothingData?["pictureUrl"] as? String ?? ""
                if picUrlStr != "" {
                    let picUrl = URL(string: picUrlStr)
                    
                    button.imageView?.contentMode = .scaleAspectFit
                    button.sd_setImage(with: picUrl, for: .normal)
                }
            }
        })
    }
    
    
    
    @IBAction func switchViewDidTouch(_ sender: Any) {
        self.containerViewController?.cycle(from: self, to: (self.containerViewController?.iconViewController)!, direction: UIViewAnimationOptions.transitionFlipFromLeft)
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
                let followingVC: AroundMeTableViewController = segue.destination as! AroundMeTableViewController
                followingVC.forAroundMe = false
            default:
                var _ = 0
        }
    }
}
