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
//              "email": _____
//          }
//      }
//  }

import Foundation

struct User {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(uid: String, firstName: String, lastName: String, email: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
