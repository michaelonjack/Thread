//
//  ClothingItemViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import FirebaseStorage

class ClothingItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var labelViewTitle: UILabel!
    @IBOutlet weak var textFieldItemName: UITextField!
    @IBOutlet weak var textFieldItemBrand: UITextField!
    @IBOutlet weak var textFieldItemLink: UITextField!
    @IBOutlet weak var imageViewClothingPicture: UIImageView!
    
    let picker = UIImagePickerController()
    let currentUserRef = FIRDatabase.database().reference(withPath: "users/" + (FIRAuth.auth()?.currentUser?.uid)!)
    let currentUserClothingImagesRef = FIRStorage.storage().reference(withPath: "images/" + (FIRAuth.auth()?.currentUser?.uid)!)
    
    var clothingType: ClothingType!
    var imageDidChange: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        // Set the title of the view according to which button they've pressed
        switch clothingType! {
            case .Top:
                labelViewTitle.text = "shirt"
            case .Bottom:
                labelViewTitle.text = "pants"
            case .Shoes:
                labelViewTitle.text = "shoes"
            case .Accessories:
                labelViewTitle.text = "accessories"
        }
        
        loadUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
        Action to handle when the user wants to save the data in the view
    */
    @IBAction func saveDidTouch(_ sender: Any) {
        let clothingItemName = textFieldItemName.text
        let clothingItemBrand = textFieldItemBrand.text
        let clothingItemLink = textFieldItemLink.text
        
        // Create a new ClothingItem object to represent the new data
        let newClothingItem = ClothingItem(name: clothingItemName!, type: clothingType, brand: clothingItemBrand!, itemUrl: clothingItemLink!)
        
        // Add the data to the database for the current user
        let currentUserClothingTypeRef = currentUserRef.child(clothingType.description)
        currentUserClothingTypeRef.setValue(newClothingItem.toAnyObject())
        
        // Enter the user's image into the database
        if imageViewClothingPicture.image != nil {
            let imageMetaData = FIRStorageMetadata()
            imageMetaData.contentType = "image/png"
        
            // Create a Data object to represent the image as a PNG
            var imageData = Data()
            imageData = UIImagePNGRepresentation(imageViewClothingPicture.image!)!
        
            // Get reference to the user's clothing type in Firebase Storage
            let currentUserClothingTypeImagesRef = currentUserClothingImagesRef.child(clothingType.description)
            
            // Add the image to Firebase Storage if it has changed
            if imageDidChange == true {
                currentUserClothingTypeImagesRef.put(imageData, metadata: imageMetaData) { (metaData, error) in
                    if error == nil {
                        // Add the image's url to the Firebase database
                        let downloadUrl = metaData?.downloadURL()?.absoluteString
                        currentUserClothingTypeRef.updateChildValues(["pictureUrl": downloadUrl!])
                    } else {
                        print(error?.localizedDescription ?? "Error uploading data to storage")
                    }
                }
            }
        }
    }
    
    
    /*
        Action to handle when the user selects the camera button
        Uses the user's camera to take a picture
    */
    @IBAction func cameraDidTouch(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picker.sourceType = UIImagePickerControllerSourceType.camera;
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        } else {
            print("not availableeeeeeeeeeeee")
        }
    }
    
    
    /*
        Action to handle when the user selects the photo library button
        Allows the user to select a photo from their phone library
    */
    @IBAction func photoLibraryDidTouch(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    /*
        Pulls the image chosen by the user (via their photo library or camera) and sets that as the view's image
        Called by cameraDidTouch and photoLibraryDidTouch
    */
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewClothingPicture.contentMode = .scaleAspectFit
        imageViewClothingPicture.image = chosenImage
        dismiss(animated:true, completion: nil)
        self.imageDidChange = true
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
        Retrieves the current user's data from the database and fills the view fields
        Called when view loads
    */
    func loadUserData() {
        
        // Load the stored image
        currentUserRef.child(clothingType.description).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            self.textFieldItemName.text = storedData?["name"] as? String ?? ""
            self.textFieldItemBrand.text = storedData?["brand"] as? String ?? ""
            self.textFieldItemLink.text = storedData?["link"] as? String ?? ""
            
            if snapshot.hasChild("pictureUrl") {
                self.currentUserClothingImagesRef.child(self.clothingType.description).data(withMaxSize: 20*1024*1024, completion: {(data, error) in
                    let clothingImage = UIImage(data:data!)
                    self.imageViewClothingPicture.image = clothingImage
                })
            }
        })
    }


}
