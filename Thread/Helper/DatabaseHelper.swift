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
        completion( User(snapshot: snapshot) )
    }
}



func getUser(withId id: String, completion: @escaping (User) -> Void) {
    let userReference = Database.database().reference(withPath: "users/" + id)
    userReference.keepSynced(true)
    userReference.observe(.value) { (snapshot) in
        completion( User(snapshot: snapshot) )
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
