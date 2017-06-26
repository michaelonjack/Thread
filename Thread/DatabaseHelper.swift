//
//  DatabaseHelper.swift
//  Thread
//
//  Created by Michael Onjack on 6/24/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation
import FirebaseStorage
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
    imageData = UIImageJPEGRepresentation(image, 1.0)!
    
    userStorageReference.putData(imageData, metadata: imageMetaData) { (metaData, error) in
        if error == nil {
            // Add the image's url to the Firebase database
            let downloadUrl = metaData?.downloadURL()?.absoluteString
            userReference.updateChildValues(["outfitPictureUrl": downloadUrl!])
            
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
    imageData = UIImageJPEGRepresentation(image, 1.0)!
    
    userStorageReference.putData(imageData, metadata: imageMetaData) { (metaData, error) in
        if error == nil {
            // Add the image's url to the Firebase database
            let downloadUrl = metaData?.downloadURL()?.absoluteString
            userReference.updateChildValues(["profilePictureUrl": downloadUrl!])
            
        }
    }
}




//////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
func getDataForUser(userid:String, completion: @escaping ([String:AnyObject]) -> ()) {
    
    Database.database().reference(withPath: "users/" + userid).observeSingleEvent(of: .value, with: { (snapshot) in
        var userData = snapshot.value as! [String:AnyObject]
        var locationData = [String:AnyObject]()
        
        let latitude = userData["latitude"] as? Double
        let longitude = userData["longitude"] as? Double
        let userLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        
        locationData["latitude"] = latitude as AnyObject
        locationData["longitude"] = longitude as AnyObject
        
        getPlacemark(forLocation: userLocation, completionHandler: { (placemark, error) in
            if let e = error {
                print(e)
            } else {
                locationData["street"] = (placemark?.addressDictionary?["Street"] ?? "") as AnyObject
                locationData["city"] = (placemark?.addressDictionary?["City"] ?? "") as AnyObject
                locationData["state"] = (placemark?.addressDictionary?["State"] ?? "") as AnyObject
                locationData["zip"] = (placemark?.addressDictionary?["ZIP"] ?? "") as AnyObject
                
                userData["location"] = locationData as AnyObject
                completion(userData)
            }
        })
        
        completion(userData)
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
