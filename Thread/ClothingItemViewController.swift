//
//  ClothingItemViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import FirebaseStorage
import NVActivityIndicatorView

class ClothingItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var labelViewTitle: UILabel!
    @IBOutlet weak var imageViewClothingPicture: UIImageView!
    @IBOutlet weak var loadingAnimationView: NVActivityIndicatorView!
    
    let picker = UIImagePickerController()
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    let currentUserStorageRef = Storage.storage().reference(withPath: "images/" + (Auth.auth().currentUser?.uid)!)
    
    var clothingItem: ClothingItem!
    var clothingType: ClothingType!
    var imageDidChange: Bool! = false
    var keyboardShowing: Bool! = false
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Adds observers to watch for keyboard events (when keyboard will show/hide call keyboardWillShow/keyboardWillHide)
    //  Starts the loading animation to show that the clothing image is loading
    //  Sets the top label view to describe the type of Clothing Item that is being displayed
    //  Loads the user's data to be displayed in the view
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clothingItem = ClothingItem()
        
        loadingAnimationView.type = .ballScaleMultiple
        loadingAnimationView.startAnimating()
        
        picker.delegate = self
        
        // Set the title of the view according to which button they've pressed
        switch clothingType! {
            case .Top:
                labelViewTitle.text = "top"
            case .Bottom:
                labelViewTitle.text = "bottom"
            case .Shoes:
                labelViewTitle.text = "shoes"
            case .Accessories:
                labelViewTitle.text = "accessories"
        }
        
        loadUserData()
        
        let swipeToSwitchItem = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(_:)))
        swipeToSwitchItem.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeToSwitchItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  saveDidTouch
    //
    //  Action to handle when the user wants to save the data in the view
    //
    @IBAction func saveDidTouch(_ sender: Any) {
        loadingAnimationView.type = .ballBeat
        loadingAnimationView.startAnimating()
        
        // Create a new id for the item if it does not currently have one
        if self.clothingItem.id == "-1" {
            self.clothingItem.setItemId(id: generateRandomId())
        }
        
        // Add the data to the database for the current user
        let currentUserClothingTypeRef = currentUserRef.child(clothingType.description)
        
        // Enter the user's image into the database
        if imageViewClothingPicture.image != nil && imageDidChange == true {
            let imageMetaData = StorageMetadata()
            imageMetaData.contentType = "image/jpeg"
        
            // Create a Data object to represent the image as a PNG
            var imageData = Data()
            imageData = UIImageJPEGRepresentation(imageViewClothingPicture.image!, 1.0)!
        
            // Get reference to the user's clothing type in Firebase Storage
            let currentUserClothingTypeImagesRef = currentUserStorageRef.child(clothingType.description)
            
            // Add the image to Firebase Storage
            currentUserClothingTypeImagesRef.putData(imageData, metadata: imageMetaData) { (metaData, error) in
                if error == nil {
                    // Add the image's url to the Firebase database
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    currentUserClothingTypeRef.updateChildValues(["pictureUrl": downloadUrl!])
                    
                    self.clothingItem.itemPictureUrl = downloadUrl!
                    
                    // Refresh the previous view controller in the navigation stack so it uses the updated clothing item image
                    var currentControllers:[UIViewController] = (self.navigationController?.viewControllers)!
                    // Get previous view controller in stack (MeContainerViewController)
                    let meVC:MeContainerViewController = currentControllers[currentControllers.count-2] as! MeContainerViewController
                    
                    // Determine if the previous VC is an instance of MeAlt
                    if ( meVC.activeViewController?.isKind(of: MeAltViewController.self) )! {
                        // If so, me must change the displayed image
                        let meAltVC:MeAltViewController = meVC.activeViewController as! MeAltViewController
                        
                        switch self.clothingType! {
                            case ClothingType.Top:
                                meAltVC.loadImage(named: "Top", button: meAltVC.buttonTop)
                            case ClothingType.Bottom:
                                meAltVC.loadImage(named: "Bottom", button: meAltVC.buttonBottom)
                            case ClothingType.Shoes:
                                meAltVC.loadImage(named: "Shoes", button: meAltVC.buttonShoes)
                            case ClothingType.Accessories:
                                meAltVC.loadImage(named: "Accessories", button: meAltVC.buttonAccessories)
                        }
                        
                    }
                    
                    self.loadingAnimationView.stopAnimating()
                        
                } else {
                    print(error?.localizedDescription ?? "Error uploading data to storage")
                    self.loadingAnimationView.stopAnimating()
                }
            }
        } else {
            self.loadingAnimationView.stopAnimating()
        }
        
        currentUserClothingTypeRef.updateChildValues(self.clothingItem.toAnyObject() as! [AnyHashable : Any])
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  cameraDidTouch
    //
    //  Action to handle when the user selects the camera button
    //  Uses the user's camera to take a picture
    //
    @IBAction func cameraDidTouch(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picker.sourceType = UIImagePickerControllerSourceType.camera;
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        } else {
            print("not availableeeeeeeeeeeee")
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  photoLibraryDidTouch
    //
    //  Action to handle when the user selects the photo library button
    //  Allows the user to select a photo from their phone library
    //
    @IBAction func photoLibraryDidTouch(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  imagePickController
    //
    //  Pulls the image chosen by the user (via their photo library or camera) and sets that as the view's image
    //  Called by cameraDidTouch and photoLibraryDidTouch
    //
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewClothingPicture.contentMode = .scaleAspectFit
        imageViewClothingPicture.image = chosenImage
        dismiss(animated:true, completion: nil)
        self.imageDidChange = true
        
        self.clothingItem.name = ""
        self.clothingItem.brand = ""
        self.clothingItem.itemUrl = ""
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  loadUserData
    //
    //  Retrieves the current user's data from the database and fills the view fields
    //  Called when view loads
    //
    func loadUserData() {
        
        // Load the stored image
        currentUserRef.child(clothingType.description).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            self.clothingItem.setItemId(id: storedData?["id"] as? String ?? "-1")
            self.clothingItem.setName(name: storedData?["name"] as? String ?? "")
            self.clothingItem.setBrand(brand: storedData?["brand"] as? String ?? "")
            self.clothingItem.setItemUrl(url: storedData?["link"] as? String ?? "")
            self.clothingItem.setItemPictureUrl(url: storedData?["pictureUrl"] as? String ?? "")
            
            if snapshot.hasChild("pictureUrl") {
                self.currentUserStorageRef.child(self.clothingType.description).getData(maxSize: 20*1024*1024, completion: {(data, error) in
                    if error == nil {
                        let clothingImage = UIImage(data:data!)
                    
                        self.imageViewClothingPicture.contentMode = .scaleAspectFit
                        self.loadingAnimationView.stopAnimating()
                        self.imageViewClothingPicture.backgroundColor = UIColor.white
                        self.imageViewClothingPicture.image = clothingImage
                    } else {
                        print(error?.localizedDescription ?? "Error loading image")
                    }
                })
            } else {
                self.loadingAnimationView.stopAnimating()
            }
        })
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  generateRandomId
    //
    //
    func generateRandomId() -> String {
        return String(arc4random_uniform(UInt32(UInt32.max)))
    }
    
    
    func swipeLeft(_ gesture: UIGestureRecognizer) {
        let vc:ClothingItemViewController = storyboard?.instantiateViewController(withIdentifier: "ClothingItemViewController") as! ClothingItemViewController
        
        switch self.clothingType! {
            case .Top:
                vc.clothingType = ClothingType.Bottom
            case .Bottom:
                vc.clothingType = ClothingType.Shoes
            case .Shoes:
                vc.clothingType = ClothingType.Accessories
            case .Accessories:
                vc.clothingType = ClothingType.Top
        }
        
        var currentControllers:[UIViewController] = (self.navigationController?.viewControllers)!
        currentControllers.removeLast()
        currentControllers.append(vc)
        self.navigationController?.setViewControllers(currentControllers, animated: true)
    }
    
    
    /////////////////////////////////////////////////////
    //
    //  prepareForSegue
    //
    //
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMoreSegue" {
            let infoVC: MoreInfoViewController = segue.destination as! MoreInfoViewController
            
            infoVC.clothingItem = self.clothingItem
            infoVC.canEdit = true
        }
    }
    
    
    @IBAction func unwindToClothingItemViewController(segue: UIStoryboardSegue) {
        print(self.clothingItem.toAnyObject())
    }

}
