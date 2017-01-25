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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Action to handle when the user wants to save the data in the view
    @IBAction func saveDidTouch(_ sender: Any) {
        let clothingItemName = textFieldItemName.text
        let clothingItemBrand = textFieldItemBrand.text
        let clothingItemLink = textFieldItemLink.text
        
        let newClothingItem = ClothingItem(name: clothingItemName!, type: clothingType, brand: clothingItemBrand!, itemUrl: clothingItemLink!)
        
        let currentUserClothingTypeRef = currentUserRef.child(clothingType.description)
        currentUserClothingTypeRef.setValue(newClothingItem.toAnyObject())
        
        if imageViewClothingPicture.image != nil {
            let imageMetaData = FIRStorageMetadata()
            imageMetaData.contentType = "image/png"
        
            var imageData = Data()
            imageData = UIImagePNGRepresentation(imageViewClothingPicture.image!)!
        
            let currentUserClothingTypeImagesRef = currentUserClothingImagesRef.child(clothingType.description)
            currentUserClothingTypeImagesRef.put(imageData, metadata: imageMetaData) { (metaData, error) in
                if error == nil {
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    currentUserClothingTypeRef.updateChildValues(["pictureUrl": downloadUrl!])
                } else {
                    print(error?.localizedDescription ?? "Error uploading data to storage")
                }
            }
        }
    }
    
    // Action to handle when the user selects the camera button
    // Uses the user's camera to take a picture
    @IBAction func cameraDidTouch(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picker.sourceType = UIImagePickerControllerSourceType.camera;
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        } else {
            print("not availableeeeeeeeeeeee")
        }
    }
    
    // Action to handle when the user selects the photo library
    // Allows the user to select a photo from their phone library
    @IBAction func photoLibraryDidTouch(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    // Sets the select image as the ImageView's image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewClothingPicture.contentMode = .scaleAspectFit
        imageViewClothingPicture.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
