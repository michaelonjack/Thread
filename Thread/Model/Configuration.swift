//
//  Configuration.swift
//  Thread
//
//  Created by Michael Onjack on 2/2/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class Configuration {
    private static let sharedConfiguration: Configuration = Configuration()
    
    var currentUser: User?
    var userCache: [String:User] = [:]
    
    private init() {
        Auth.auth().addStateDidChangeListener { (auth, newUser) in
            // Set the current user
            if (Auth.auth().currentUser != nil) {
                getCurrentUser(completion: { (currentUser) in
                    self.userCache[currentUser.uid] = currentUser
                    self.currentUser = currentUser
                })
            }
        }
    }
    
    class func shared() -> Configuration {
        return sharedConfiguration
    }
}
