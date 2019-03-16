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
import SDWebImage

class User {
    let uid: String
    var firstName: String
    var lastName: String
    var email: String
    var lastCheckIn: Date?
    var status: String?
    var location: CLLocation? {
        didSet {
            locationStr = nil
        }
    }
    var locationStr: String?
    var profilePicture: UIImage?
    var profilePictureUrl: URL?
    var outfitPictureUrl: URL?
    var clothingItems: [ClothingType:ClothingItem] = [:]
    var favoritedItems: [ClothingItem] = []
    var followingUserIds: [String] = []
    var followerUserIds: [String] = []
    var blockedUserIds: [String] = []
    var blockedByUserIds: [String] = []
    
    // Computed properties
    var name: String {
        return firstName + " " + lastName
    }
    
    var lastCheckInStr: String {
        guard let lastCheckIn = lastCheckIn else { return "" }
        var timeElapsedStr = ""
        
        let secondsSince = Int(Date().timeIntervalSince(lastCheckIn))
        let minutesSince = secondsSince / 60
        let hoursSince = minutesSince / 60
        let daysSince = hoursSince / 24
        
        if secondsSince / 60 == 0 {
            timeElapsedStr = String(secondsSince) + " seconds ago"
        } else if minutesSince / 60 == 0 {
            timeElapsedStr = String(minutesSince) + " minutes ago"
        } else if hoursSince / 24 == 0 {
            timeElapsedStr = String(hoursSince) + " hours ago"
        } else {
            timeElapsedStr = String(daysSince) + " days ago"
        }
        
        return timeElapsedStr
    }
    
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
        status = snapshotValue["status"] as? String
        
        if let profilePictureUrlStr = snapshotValue["profilePictureUrl"] as? String {
            profilePictureUrl = URL(string: profilePictureUrlStr)
        }
        
        if let outfitPictureUrlStr = snapshotValue["outfitPictureUrl"] as? String {
            outfitPictureUrl = URL(string: outfitPictureUrlStr)
        }
        
        if let lastCheckInStr = snapshotValue["lastCheckIn"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            self.lastCheckIn = dateFormatter.date(from: lastCheckInStr)
        }
        
        if let latitude = snapshotValue["latitude"] as? Double, let longitude = snapshotValue["longitude"] as? Double {
            location = CLLocation(latitude: latitude, longitude: longitude)
        }
        
        let itemsSnapshot = snapshot.childSnapshot(forPath: "items")
        for item in itemsSnapshot.children {
            let clothingItem = ClothingItem(snapshot: item as! DataSnapshot)
            clothingItems[clothingItem.type] = clothingItem
        }
        
        let favoritesSnapshot = snapshot.childSnapshot(forPath: "favorites")
        for item in favoritesSnapshot.children {
            let favoritedItem = ClothingItem(snapshot: item as! DataSnapshot, withIdAsKey: true)
            favoritedItems.append(favoritedItem)
        }
        
        let followingSnapshot = snapshot.childSnapshot(forPath: "following")
        for child in followingSnapshot.children {
            let user = child as! DataSnapshot
            if user.key == uid { return }
            followingUserIds.append(user.key)
        }
        
        let followersSnapshot = snapshot.childSnapshot(forPath: "followers")
        for child in followersSnapshot.children {
            let user = child as! DataSnapshot
            if user.key == uid { return }
            followerUserIds.append(user.key)
        }
        
        let blockedSnapshot = snapshot.childSnapshot(forPath: "blocked")
        for child in blockedSnapshot.children {
            let user = child as! DataSnapshot
            if user.key == uid { return }
            blockedUserIds.append(user.key)
        }
        
        let blockedBySnapshot = snapshot.childSnapshot(forPath: "blockedBy")
        for child in blockedBySnapshot.children {
            let user = child as! DataSnapshot
            if user.key == uid { return }
            blockedByUserIds.append(user.key)
        }
    }
    
    func toAnyObject() -> Any {
        var clothingItemsDict: [String:Any] = [:]
        for (type, item) in clothingItems {
            clothingItemsDict[type.description] = item.toAnyObject()
        }
        
        var favoritedItemsDict: [String:Any] = [:]
        for item in favoritedItems {
            favoritedItemsDict[item.id] = item.toAnyObject()
        }
        
        var followingDict: [String:Any] = [:]
        for userId in followingUserIds {
            followingDict[userId] = true
        }
        
        var followersDict: [String:Any] = [:]
        for userId in followerUserIds {
            followersDict[userId] = true
        }
        
        var blockedDict: [String:Any] = [:]
        for userId in blockedUserIds {
            blockedDict[userId] = true
        }
        
        var blockedByDict: [String:Any] = [:]
        for userId in blockedByUserIds {
            blockedByDict[userId] = true
        }
        
        var dict: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "items": clothingItemsDict,
            "favorites": favoritedItemsDict,
            "following": followingDict,
            "followers": followersDict,
            "blocked": blockedDict,
            "blockedBy": blockedByDict
        ]
        
        if let profilePictureUrl = profilePictureUrl {
            dict["profilePictureUrl"] = profilePictureUrl.absoluteString
        }
        
        if let lastCheckIn = lastCheckIn {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            dict["lastCheckIn"] = dateFormatter.string(from: lastCheckIn)
        }
        
        if let latitude = location?.coordinate.latitude {
            dict["latitude"] = latitude
        }
        
        if let longitude = location?.coordinate.longitude {
            dict["longitude"] = longitude
        }
        
        if let status = status {
            dict["status"] = status
        }
        
        return dict
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
    
    func getProfilePicture(completion: @escaping (UIImage?) -> Void) {
        
        if let profilePicture = profilePicture {
            completion(profilePicture)
            return
        }
        
        else if let imageUrl = profilePictureUrl {
            SDWebImageDownloader.shared().downloadImage(with: imageUrl, options: SDWebImageDownloaderOptions.init(rawValue: 0), progress: nil) { (image, _, error, _) in
                
                if error != nil {
                    completion(nil)
                    return
                }
                
                self.profilePicture = image
                completion(image)
                return
            }
        } else {
            completion(nil)
            return
        }
    }
    
    func getDistanceFrom(user: User) -> CLLocationDistance? {
        guard let otherUserLocation = user.location else { return nil }
        guard let userLocation = location else { return nil }
        
        return userLocation.distance(from: otherUserLocation)
    }
    
    func follow(userId: String) {
        followingUserIds.append(userId)
        
        // Update the current user's following list for the new user
        let currentUserFollowingReference = Database.database().reference(withPath: "users/" + self.uid + "/following")
        currentUserFollowingReference.updateChildValues([userId:true])
        
        // Update the other user's followers list for the current user
        let otherUserFollowersReference = Database.database().reference(withPath: "users/" + userId + "/followers")
        otherUserFollowersReference.updateChildValues([self.uid : true])
    }
    
    func unfollow(userId: String) {
        followingUserIds.removeAll { (uid) -> Bool in
            return userId == uid
        }
        
        // Remove the user from the current user's list of followed users
        let currentUserFollowingReference = Database.database().reference(withPath: "users/" + self.uid + "/following/" + userId)
        currentUserFollowingReference.removeValue()
        
        // Remove the current user from the other user's list of followed by users
        let otherUserFollowersReference = Database.database().reference(withPath: "users/" + userId + "/followers/" + self.uid)
        otherUserFollowersReference.removeValue()
    }
    
    func block(userId: String) {
        blockedUserIds.append(userId)
        
        // Update the current user's blocked list for the new user
        let currentUserBlockedReference = Database.database().reference(withPath: "users/" + self.uid + "/blocked")
        currentUserBlockedReference.updateChildValues([userId:true])
        
        // Update the other user's blocked by list for the current user
        let otherUserBlockedByReference = Database.database().reference(withPath: "users/" + userId + "/blockedBy")
        otherUserBlockedByReference.updateChildValues([self.uid : true])
    }
    
    func unblock(userId: String) {
        blockedUserIds.removeAll { (uid) -> Bool in
            return userId == uid
        }
        
        // Remove the user from the current user's list of blocked users
        let currentUserBlockedReference = Database.database().reference(withPath: "users/" + self.uid + "/blocked/" + userId)
        currentUserBlockedReference.removeValue()
        
        // Remove the current user from the other user's list of blocked by users
        let otherUserBlockedByReference = Database.database().reference(withPath: "users/" + userId + "/blockedBy/" + self.uid)
        otherUserBlockedByReference.removeValue()
    }
    
    func getFollowedItems(completion:@escaping ([(User,ClothingItem)]) -> Void) {
        
        var followedItems: [(User,ClothingItem)] = []
        
        // If the user has no followers, return
        let numberOfFollowedUsers = followingUserIds.count
        if numberOfFollowedUsers == 0 {
            completion(followedItems)
            return
        }
        
        for (index, userId) in followingUserIds.enumerated() {
            getUser(withId: userId) { (user) in
                if let top = user.clothingItems[.top] {
                    followedItems.append( (user, top) )
                }
                
                if let bottom = user.clothingItems[.bottom] {
                    followedItems.append( (user, bottom) )
                }
                
                if let shoes = user.clothingItems[.shoes] {
                    followedItems.append( (user, shoes) )
                }
                
                if let accessories = user.clothingItems[.accessories] {
                    followedItems.append( (user, accessories) )
                }
                
                DispatchQueue.main.async {
                    // Check if all of the followed users have been accounted for
                    if index + 1 == numberOfFollowedUsers {
                        completion(followedItems)
                    }
                }
            }
        }
    }
    
    func save() {
        let userReference = Database.database().reference(withPath: "users/")
        userReference.updateChildValues([uid : toAnyObject()])
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}


extension User: Hashable {
    var hashValue: Int {
        return self.uid.hashValue
    }
}
