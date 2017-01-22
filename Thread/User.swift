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
    
    init(uid: String, firstName: String, lastName: String, email: String, latitude: Double, longitude: Double) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(user: FIRUser, firstName: String, lastName: String) {
        self.uid = user.uid
        self.email = user.email!
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = 0
        self.longitude = 0
    }
    
    init(snapshot: FIRDataSnapshot) {
        uid = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        email = snapshotValue["email"] as! String
        latitude = snapshotValue["latitude"] as! Double
        longitude = snapshotValue["longitude"] as! Double
    }
    
    func toAnyObject() -> Any {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}
