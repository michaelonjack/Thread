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
    @IBOutlet weak var loadingAnimationView: NVActivityIndicatorView!
    
    var userRef: FIRDatabaseReference!
    var userStorageRef: FIRStorageReference!
    
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
        
        userRef = FIRDatabase.database().reference(withPath: "users/" + user.uid)
        userStorageRef = FIRStorage.storage().reference(withPath: "images/" + user.uid)
        
        loadUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    /////////////////////////////////////////////////////
    //
    //  likeDidTouch
    //
    //  Action to handle when the user likes (hearts another user's clothing item
    //
    @IBAction func likeDidTouch(_ sender: Any) {
        
        /*
        let likeButton = sender as! UIButton
        
        if likeButton.image(for: UIControlState.normal)?.accessibilityIdentifier == "Love" {
            likeButton.setImage(UIImage(named: "LoveClicked"), for: UIControlState.normal)
        } else {
            likeButton.setImage(UIImage(named:"Love"), for: UIControlState.normal)
        }
        */
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
            
            self.labelItemName.text = storedData?["name"] as? String ?? ""
            self.textViewItemLink.text = storedData?["link"] as? String ?? ""
            
            if snapshot.hasChild("pictureUrl") {
                self.userStorageRef.child(self.clothingType.description).data(withMaxSize: 20*1024*1024, completion: {(data, error) in
                    if error == nil {
                        let clothingImage = UIImage(data:data!)
                    
                        self.imageViewClothingPicture.contentMode = .scaleAspectFit
                        self.loadingAnimationView.stopAnimating()
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

}
