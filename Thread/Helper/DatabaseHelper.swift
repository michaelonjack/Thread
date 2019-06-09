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

let configuration = Configuration.shared()

func getCurrentUser(completion: @escaping (User) -> Void) {
    
    let userReference = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    userReference.keepSynced(true)
    userReference.observe(.value) { (snapshot) in
        
        let currentUser = User(snapshot: snapshot)
        
        // Check if the user's profile picture has been cached to prevent unnecessary reloading
        if let cachedProfilePictureData = UserDefaults.standard.data(forKey: currentUser.uid + "-profilePicture") {
            currentUser.profilePicture = UIImage(data: cachedProfilePictureData)
        }
        
        completion( currentUser )
    }
}



func getUser(withId id: String, completion: @escaping (User) -> Void) {
    
    // Check if the user is cached first
    if let user = configuration.userCache.object(forKey: id as NSString) {
        completion( user )
        return
    }
    
    let userReference = Database.database().reference(withPath: "users/" + id)
    userReference.keepSynced(true)
    userReference.observeSingleEvent(of: .value) { (snapshot) in
        let user = User(snapshot: snapshot)
        
        // Save the user to the cache
        configuration.userCache.setObject(user, forKey: user.uid as NSString)
        
        completion( user )
    }
}



func getPlaces(completion: @escaping ([Place]) -> Void) {
    let placeReference = Database.database().reference(withPath: "places")
    placeReference.keepSynced(true)
    placeReference.observeSingleEvent(of: .value) { (snapshot) in
        var places: [Place] = []
        for childSnapshot in snapshot.children {
            let place = Place(snapshot: childSnapshot as! DataSnapshot)
            places.append(place)
        }
        
        completion(places)
    }
}



func updateDataForUser(userid:String, key:String, value:AnyObject) {
    Database.database().reference(withPath: "users/" + userid).updateChildValues([key:value])
}



func uploadImage(toLocation path:String, image: UIImage, completion: @escaping (_ url: URL?, _ error: Error?) -> Void ) {
    let storageReference = Storage.storage().reference(withPath: path)
    
    let imageMetaData = StorageMetadata()
    imageMetaData.contentType = "image/jpeg"
    
    var imageData = Data()
    imageData = image.jpegData(compressionQuality: 1.0)!
    
    storageReference.putData(imageData, metadata: imageMetaData) { (metaData, error) in
        if error == nil {
            storageReference.downloadURL(completion: { (url, error) in
                completion(url, error)
            })
        }
    }
}
