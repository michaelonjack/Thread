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
        
        var dict: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "latitude": location?.coordinate.latitude ?? 0.0,
            "longitude": location?.coordinate.longitude ?? 0.0,
            "items": clothingItemsDict,
            "favorites": favoritedItemsDict,
            "following": followingDict
        ]
        
        if let profilePictureUrl = profilePictureUrl {
            dict["profilePictureUrl"] = profilePictureUrl.absoluteString
        }
        
        if let lastCheckIn = lastCheckIn {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            dict["lastCheckIn"] = dateFormatter.string(from: lastCheckIn)
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
