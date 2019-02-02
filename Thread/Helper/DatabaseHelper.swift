//
//  DatabaseHelper.swift
//  Thread
//
//  Created by Michael Onjack on 6/24/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import CoreLocation




//////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
func updateDataForUser(userid:String, key:String, value:AnyObject) {
    Database.database().reference(withPath: "users/" + userid).updateChildValues([key:value])
}




//////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
func uploadOutfitPictureForUser(userid:String, image:UIImage) {
    let userReference = Database.database().reference(withPath: "users/" + userid)
    let userStorageReference = Storage.storage().reference(withPath: "images/" + userid + "/OutfitPicture")
    
    let imageMetaData = StorageMetadata()
    imageMetaData.contentType = "image/jpeg"
    
    var imageData = Data()
    imageData = image.jpegData(compressionQuality: 1.0)!
    
    userStorageReference.putData(imageData, metadata: imageMetaData) { (metaData, error) in
        if error == nil {
            // Add the image's url to the Firebase database
            userStorageReference.downloadURL(completion: { (url, error) in
                if error == nil {
                    let downloadUrl = url?.absoluteString
                    userReference.updateChildValues(["outfitPictureUrl": downloadUrl!])
                } else {
                    print(error as? String ?? "")
                }
            })
        }
    }
}



//////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
func uploadProfilePictureForUser(userid:String, image:UIImage) {
    let userReference = Database.database().reference(withPath: "users/" + userid)
    let userStorageReference = Storage.storage().reference(withPath: "images/" + userid + "/ProfilePicture")
    
    let imageMetaData = StorageMetadata()
    imageMetaData.contentType = "image/jpeg"
    
    var imageData = Data()
    imageData = image.jpegData(compressionQuality: 1.0)!
    
    userStorageReference.putData(imageData, metadata: imageMetaData) { (metaData, error) in
        if error == nil {
            // Add the image's url to the Firebase database
            userStorageReference.downloadURL(completion: { (url, error) in
                if error == nil {
                    let downloadUrl = url?.absoluteString
                    userReference.updateChildValues(["profilePictureUrl": downloadUrl!])
                } else {
                    print(error as? String ?? "")
                }
            })
        }
    }
}



//////////////////////////////////////////////////////////////////////////////////////
//
//  isFollowingUser
//
//
//
func isFollowingUser(userid:String, completion: @escaping (Bool) -> ()) {
    let followRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)! + "/Following")
    followRef.observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(userid) {
            completion(true)
        } else {
            completion(false)
        }
    })
    
}




//////////////////////////////////////////////////////////////////////////////////////
//
//  followUser
//
//
//
func followUser(userid:String) {
    let followRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)! + "/Following")
    followRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
        // Add the user to their Following list if they have not already added this user
        if !snapshot.hasChild(userid) {
            followRef.updateChildValues( [userid : true] )
        }
    })
}




//////////////////////////////////////////////////////////////////////////////////////
//
//  unfollowUser
//
//
//
func unfollowUser(userid:String) {
    let followRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)! + "/Following")
    followRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
        // Remove the user from the follow list
        if snapshot.hasChild(userid) {
            followRef.child(userid).removeValue()
        }
    })
}




//////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: {
        placemarks, error in
        
        if let err = error {
            completionHandler(nil, err.localizedDescription)
        } else if let placemarkArray = placemarks {
            if let placemark = placemarkArray.first {
                completionHandler(placemark, nil)
            } else {
                completionHandler(nil, "Placemark was nil")
            }
        } else {
            completionHandler(nil, "Unknown error")
        }
    })
    
}
