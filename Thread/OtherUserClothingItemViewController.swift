//
//  OtherUserClothingItemViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/29/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import FirebaseStorage
import NVActivityIndicatorView

class OtherUserClothingItemViewController: UIViewController {

    @IBOutlet weak var imageViewClothingPicture: UIImageView!
    @IBOutlet weak var labelViewTitle: UILabel!
    @IBOutlet weak var labelItemName: UILabel!
    @IBOutlet weak var textViewItemLink: UITextView!
    @IBOutlet weak var buttonFavoriteClothingItem: UIButton!
    @IBOutlet weak var loadingAnimationView: NVActivityIndicatorView!
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    
    var userRef: DatabaseReference!
    var userStorageRef: StorageReference!
    
    var clothingItem: ClothingItem!
    var clothingType: ClothingType!
    var user: User!
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Begins the loading animation to show a picture is being loaded into view
    //  Sets the view's title
    //  Loads the user's data into view
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clothingItem = ClothingItem()

        loadingAnimationView.type = .ballScaleMultiple
        loadingAnimationView.startAnimating()
        
        // Set the title of the view according to which button they've pressed
        switch clothingType! {
        case .Top:
            labelViewTitle.text = user.firstName + "'s top"
        case .Bottom:
            labelViewTitle.text = user.firstName + "'s bottom"
        case .Shoes:
            labelViewTitle.text = user.firstName + "'s shoes"
        case .Accessories:
            labelViewTitle.text = user.firstName + "'s accessories"
        }
        
        userRef = Database.database().reference(withPath: "users/" + user.uid)
        userStorageRef = Storage.storage().reference(withPath: "images/" + user.uid)
        
        loadUserData()
        setFavoriteButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  setFavoritesButton
    //
    //  Sets the favorite button to the correct image depending on its state
    //
    func setFavoriteButton() {
        currentUserRef.child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            print(self.clothingItem.id)
            if snapshot.hasChild(self.clothingItem.id) {
                DispatchQueue.main.async {
                    self.buttonFavoriteClothingItem.setImage(UIImage(named: "FavoriteClicked"), for: .normal)
                }
            }
        })
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  loadUserData
    //
    //  Retrieves the user's data from the database and fills the view fields
    //  Called when view loads
    //
    func loadUserData() {
        
        // Load the stored image
        userRef.child(clothingType.description).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            self.clothingItem.setItemId(id: storedData?["id"] as? String ?? "-1")
            self.clothingItem.setName(name: storedData?["name"] as? String ?? "")
            self.clothingItem.setBrand(brand: storedData?["brand"] as? String ?? "")
            self.clothingItem.setItemUrl(url: storedData?["link"] as? String ?? "")
            self.clothingItem.setItemPictureUrl(url: storedData?["pictureUrl"] as? String ?? "")
            
            if snapshot.hasChild("pictureUrl") {
                self.userStorageRef.child(self.clothingType.description).getData(maxSize: 20*1024*1024, completion: {(data, error) in
                    if error == nil {
                        let clothingImage = UIImage(data:data!)
                    
                        self.imageViewClothingPicture.contentMode = .scaleAspectFit
                        self.loadingAnimationView.stopAnimating()
                        self.imageViewClothingPicture.backgroundColor = UIColor.white
                        self.imageViewClothingPicture.image = clothingImage
                    } else {
                        print(error?.localizedDescription ?? "Error loading clothing image")
                    }
                })
            } else {
                self.loadingAnimationView.stopAnimating()
            }
        })
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  favoriteDidTouch
    //
    //  Action to handle when the user favorites (hearts) another user's clothing item
    //
    @IBAction func favoriteDidTouch(_ sender: Any) {
        
        currentUserRef.child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Add the clothing item to their Favorites list if they have not already added the item
            if !snapshot.hasChild(self.clothingItem.id) {
                self.currentUserRef.child("Favorites").updateChildValues( [self.clothingItem.id : self.clothingItem.toAnyObject()] )
                
                DispatchQueue.main.async {
                    self.buttonFavoriteClothingItem.setImage( UIImage(named: "FavoriteClicked"), for: .normal )
                }
                
            } else {
                
                self.currentUserRef.child("Favorites/" + self.clothingItem.id).removeValue()
                
                DispatchQueue.main.async {
                    self.buttonFavoriteClothingItem.setImage( UIImage(named: "Favorite"), for: .normal )
                }
                
            }
        })
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
            infoVC.canEdit = false
        }
    }

}
