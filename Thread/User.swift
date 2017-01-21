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
    let latitude: Float
    let longitude: Float
    
    init(uid: String, firstName: String, lastName: String, email: String, latitude: Float, longitude: Float) {
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
