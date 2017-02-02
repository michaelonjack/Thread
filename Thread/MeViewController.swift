//
//  MeViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/17/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import FirebaseStorage

class MeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var buttonProfilePicture: UIButton!
    @IBOutlet weak var labelGreeting: UILabel!
    
    let currentUserRef = FIRDatabase.database().reference(withPath: "users/" + (FIRAuth.auth()?.currentUser?.uid)!)
    let currentUserStorageRef = FIRStorage.storage().reference(withPath: "images/" + (FIRAuth.auth()?.currentUser?.uid)!)
    
    let imagePicker = UIImagePickerController()
    
    
    
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
    
    
    /*
        Handles the action when the profile picture button is pressed.
        Launches the user's camera so they can take a new picture and then saves that image to the database
    */
    @IBAction func profilePictureDidTouch(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("not availableeeeeeeeeeeee")
        }
    }
    
    
    
    /*
     Pulls the image chosen by the user (via their camera) and sets that as their profile picture in the view
     Called by profilePictureDidTouch
     */
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        buttonProfilePicture.setImage(chosenImage, for: .normal)
        buttonProfilePicture.imageView?.contentMode = .scaleAspectFill
        
        let imageMetaData = FIRStorageMetadata()
        imageMetaData.contentType = "image/png"
            
        // Create a Data object to represent the image as a PNG
        var imageData = Data()
        imageData = UIImageJPEGRepresentation(chosenImage, 1.0)!
            
        // Get reference to the user's clothing type in Firebase Storage
        let currentUserProfilePictureRef = currentUserStorageRef.child("ProfilePicture")
            
        // Add the image to Firebase Storage
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

    
    
    /*
        Pulls the user's profile picture from the database if it exists
    */
    func loadProfilePicture() {
        // Load the stored image
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            let firstName = storedData?["firstName"] as? String ?? ""
            
            self.labelGreeting.text = "Hi, " + firstName
            
            // Load profile picture if it exists
            if snapshot.hasChild("profilePictureUrl") {
                self.currentUserStorageRef.child("ProfilePicture").data(withMaxSize: 20*1024*1024, completion: {(data, error) in
                    let profilePicture = UIImage(data:data!)
                    
                    self.buttonProfilePicture.setImage(profilePicture, for: .normal)
                    self.buttonProfilePicture.imageView?.contentMode = .scaleAspectFill
                })
            } else {
                print("blah")
            }
        })
    }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
        default:
            let defaultVC:ClothingItemViewController = segue.destination as! ClothingItemViewController
            defaultVC.clothingType = nil
        }
    }

}
