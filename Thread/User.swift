//
//  User.swift
//  Thread
//
//  Created by Michael Onjack on 1/21/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

//Structure of User:
//  {
//      "user": {
//          **uid**: {
//              "firstName": ____,
//              "lastName": _____,
//              "email": _____,
//              "latitude": ____,
//              "longitude": ____
//          }
//      }
//  }

import Foundation

struct User {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let latitude: Double
    let longitude: Double
    let status: String
    var profilePicture: UIImage?
    var profilePictureUrl: String?
    var outfitPictureUrl: String?
    
    init(uid: String, firstName: String, lastName: String, email: String, status: String, latitude: Double, longitude: Double) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(user: Firebase.User, firstName: String, lastName: String, status: String) {
        self.uid = user.uid
        self.email = user.email!
        self.firstName = firstName
        self.lastName = lastName
        self.status = status
        self.latitude = 0
        self.longitude = 0
    }
    
    init(snapshot: DataSnapshot) {
        uid = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        email = snapshotValue["email"] as! String
        status = snapshotValue["status"] as? String ?? ""
        latitude = snapshotValue["latitude"] as! Double
        longitude = snapshotValue["longitude"] as! Double
        profilePictureUrl = snapshotValue["profilePictureUrl"] as? String
        outfitPictureUrl = snapshotValue["outfitPictureUrl"] as? String
    }
    
    func toAnyObject() -> Any {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "status": status,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}
