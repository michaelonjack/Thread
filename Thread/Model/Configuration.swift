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
    
    // The maximum number of meters away from the current user another user can be in order to show on the map
    var maximumUserDistance: Double
    // The maximum number of meters away from a place another user can be in order to show in the Nearby Items section
    var maximumItemDistance: Double
    var currentUser: User?
    var places: [Place] = []
    var userCache: [String:User] = [:]
    
    private init() {
        // Check for cached values
        maximumUserDistance = UserDefaults.standard.value(forKey: "maxUserDistance") as? Double ?? 0
        maximumItemDistance = UserDefaults.standard.value(forKey: "maxItemDistance") as? Double ?? 0
        
        Auth.auth().addStateDidChangeListener { (auth, newUser) in
            // Set the current user
            if (Auth.auth().currentUser != nil) {
                getCurrentUser(completion: { (currentUser) in
                    
                    // Copy over any cached profile pictures
                    if currentUser.profilePictureUrl2 == self.currentUser?.profilePictureUrl2 {
                        currentUser.profilePicture2 = self.currentUser?.profilePicture2
                    }
                    
                    if currentUser.profilePictureUrl3 == self.currentUser?.profilePictureUrl3 {
                        currentUser.profilePicture3 = self.currentUser?.profilePicture3
                    }
                    
                    self.userCache[currentUser.uid] = currentUser
                    self.currentUser = currentUser
                })
            }
        }
        
        let configurationReference = Database.database().reference(withPath: "configuration")
        configurationReference.keepSynced(true)
        configurationReference.observeSingleEvent(of: .value) { (snapshot) in
            if let configDict = snapshot.value as? [String:AnyObject] {
                let maxUserDistance = configDict["maxUserDistance"] as? Double ?? 0
                let maxItemDistance = configDict["maxItemDistance"] as? Double ?? 0
                
                self.maximumUserDistance = maxUserDistance
                self.maximumItemDistance = maxItemDistance
                
                // Cache basic properties
                UserDefaults.standard.setValue(maxUserDistance, forKey: "maxUserDistance")
                UserDefaults.standard.setValue(maxItemDistance, forKey: "maxItemDistance")
            }
        }
    }
    
    class func shared() -> Configuration {
        return sharedConfiguration
    }
}
