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
    
    var maximumUserDistance: Double
    var currentUser: User?
    var places: [Place] = []
    var userCache: [String:User] = [:]
    
    private init() {
        // Check for cached values
        maximumUserDistance = UserDefaults.standard.value(forKey: "maxUserDistance") as? Double ?? 0
        
        Auth.auth().addStateDidChangeListener { (auth, newUser) in
            // Set the current user
            if (Auth.auth().currentUser != nil) {
                getCurrentUser(completion: { (currentUser) in
                    self.userCache[currentUser.uid] = currentUser
                    self.currentUser = currentUser
                })
            }
        }
        
        let configurationReference = Database.database().reference(withPath: "configuration")
        configurationReference.keepSynced(true)
        configurationReference.observeSingleEvent(of: .value) { (snapshot) in
            if let configDict = snapshot.value as? [String:AnyObject] {
                let maxDistance = configDict["maxUserDistance"] as? Double ?? 0
                
                self.maximumUserDistance = maxDistance
                
                // Cache basic properties
                UserDefaults.standard.setValue(maxDistance, forKey: "maxUserDistance")
            }
        }
    }
    
    class func shared() -> Configuration {
        return sharedConfiguration
    }
}
