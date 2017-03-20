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

class MeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var buttonProfilePicture: UIButton!
    @IBOutlet weak var labelGreeting: UILabel!
    
    let currentUserRef = FIRDatabase.database().reference(withPath: "users/" + (FIRAuth.auth()?.currentUser?.uid)!)
    let currentUserStorageRef = FIRStorage.storage().reference(withPath: "images/" + (FIRAuth.auth()?.currentUser?.uid)!)
    let imagePicker = UIImagePickerController()
    
    var containerViewController: MeContainerViewController?
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Shapes the user's profile picture into a circle and loads it from storage
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

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
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Error -- Camera")
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  imagePickerController
    //
    //  Pulls the image chosen by the user (via their camera) and sets it as their profile picture in the view
    //  Called by profilePictureDidTouch
    //
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        // The image taken by the user's camera
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Sets the user's profile picture to be this image
        buttonProfilePicture.setImage(chosenImage, for: .normal)
        buttonProfilePicture.imageView?.contentMode = .scaleAspectFill
        
        // Creates the image metadata for Firebase Storage
        let imageMetaData = FIRStorageMetadata()
        imageMetaData.contentType = "image/jpeg"
            
        // Create a Data object to represent the image as a JPEG
        var imageData = Data()
        imageData = UIImageJPEGRepresentation(chosenImage, 0.05)!
            
        // Get reference to the user's profile picture in Firebase Storage
        let currentUserProfilePictureRef = currentUserStorageRef.child("ProfilePicture")
            
        // Add the selected image to Firebase Storage
        currentUserProfilePictureRef.put(imageData, metadata: imageMetaData) { (metaData, error) in
            if error == nil {
                    // Add the image's url to the Firebase database
                let downloadUrl = metaData?.downloadURL()?.absoluteString
                self.currentUserRef.updateChildValues(["profilePictureUrl": downloadUrl!])
                    
            } else {
                print(error?.localizedDescription ?? "Error uploading data to storage")
            }
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
                self.currentUserStorageRef.child("ProfilePicture").data(withMaxSize: 20*1024*1024, completion: {(data, error) in
                    if data != nil {
                        let profilePicture = UIImage(data:data!)
                        
                        // Sets the user's profile picture to the loaded image
                        self.buttonProfilePicture.setImage(profilePicture, for: .normal)
                        self.buttonProfilePicture.imageView?.contentMode = .scaleAspectFill
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
                let followingVC: AroundMeTableViewController = segue.destination as! AroundMeTableViewController
                followingVC.forAroundMe = false
            default:
                var _ = 0
        }
    }

}


