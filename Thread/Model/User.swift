//
//  User.swift
//  Thread
//
//  Created by Michael Onjack on 1/21/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseAuth
import FirebaseDatabase

class User {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    var status: String?
    var location: CLLocation? {
        didSet {
            locationStr = nil
        }
    }
    var locationStr: String?
    var profilePicture: UIImage?
    var profilePictureUrl: String?
    var outfitPictureUrl: String?
    var clothingItems: [ClothingItem] = []
    
    init(uid:String, firstName: String, lastName: String, email: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    init(snapshot: DataSnapshot) {
        uid = snapshot.key
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        firstName = snapshotValue["firstName"] as? String ?? ""
        lastName = snapshotValue["lastName"] as? String ?? ""
        email = snapshotValue["email"] as? String ?? ""
        status = snapshotValue["status"] as? String ?? ""
        profilePictureUrl = snapshotValue["profilePictureUrl"] as? String
        outfitPictureUrl = snapshotValue["outfitPictureUrl"] as? String
        
        if let latitude = snapshotValue["latitude"] as? Double, let longitude = snapshotValue["longitude"] as? Double {
            location = CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    func toAnyObject() -> Any {
        var clothingItemsDict: [String:Any] = [:]
        for item in clothingItems {
            clothingItemsDict[item.type.description] = item.toAnyObject()
        }
        
        return [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "status": status ?? "",
            "latitude": location?.coordinate.latitude ?? 0.0,
            "longitude": location?.coordinate.longitude ?? 0.0,
            "profilePictureUrl": profilePictureUrl ?? "",
            "outfitPictureUrl": outfitPictureUrl ?? "",
            "items": clothingItemsDict
        ]
    }
    
    func getLocationStr(completion: @escaping (_ location: String?) -> Void) {
        // If we've already retrieved the string representation of the current location, return that
        if let locationStr = locationStr {
            completion(locationStr)
            return
        }
        
        // Make sure we actually have a location
        guard let location = self.location else {
            completion(nil)
            return
        }
        
        // Retrieve details about the current location
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placeMark = placemarks?.first else {
                completion(nil)
                return
            }
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
                return
            }
            
            if let city = placeMark.locality, let state = placeMark.administrativeArea {
                completion(city + ", " + state)
                return
            } else if let state = placeMark.administrativeArea, let country = placeMark.country {
                completion(state + ", " + country)
                return
            } else if let country = placeMark.country {
                completion(country)
                return
            }
            
            completion(nil)
            return
        }
    }
}
