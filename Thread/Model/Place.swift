//
//  Place.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase
import SDWebImage

class Place {
    let id: String
    let name: String
    let blurb: String
    var weather: WeatherType
    var temperature: Double
    var humidity: Double
    var windSpeed: Double
    var location: CLLocation
    var lastUpdated: Date?
    var image: UIImage?
    var imageUrls: [URL] = []
    var nearbyItems: [(User, ClothingItem)] = []
    
    var minutesSinceLastUpdate: Int {
        guard let lastUpdated = lastUpdated else { return Int.max }
        
        let secondsSince = Int(Date().timeIntervalSince(lastUpdated))
        let minutesSince = secondsSince / 60
        
        return minutesSince
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        id = snapshot.key
        name = snapshotValue["name"] as? String ?? ""
        blurb = snapshotValue["blurb"] as? String ?? ""
        temperature = snapshotValue["temperature"] as? Double ?? 0.0
        humidity = snapshotValue["humidity"] as? Double ?? 0.0
        windSpeed = snapshotValue["windSpeed"] as? Double ?? 0.0
        
        let latitude = snapshotValue["latitude"] as? Double ?? 0.0
        let longitude = snapshotValue["longitude"] as? Double ?? 0.0
        location = CLLocation(latitude: latitude, longitude: longitude)
        
        let weatherType: String = snapshotValue["weather"] as? String ?? ""
        let weatherDescription = snapshotValue["weatherDescription"] as? String ?? ""
        
        weather = WeatherType(name: weatherType, description: weatherDescription)
        
        let imagesSnapshot = snapshot.childSnapshot(forPath: "imageUrls")
        for childSnapshot in imagesSnapshot.children {
            let imageUrlSnapshot = childSnapshot as! DataSnapshot
            if let imageUrlStr = imageUrlSnapshot.value as? String, let imageUrl = URL(string: imageUrlStr) {
                imageUrls.append(imageUrl)
            }
        }
        
        if let lastUpdatedStr = snapshotValue["lastUpdated"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            self.lastUpdated = dateFormatter.date(from: lastUpdatedStr)
        }
        
        getNearbyItems()
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        if let image = image {
            completion(image)
            return
        }
        
        SDWebImageManager.shared.loadImage(with: imageUrls[0], options: .continueInBackground, progress: nil) { (image, _, error, _, _, _) in
            if error != nil {
                completion(nil)
                return
            }
            
            self.image = image
            completion(image)
            return
        }
    }
    
    func updateWeather(using data: OpenWeatherMapData) {
        self.temperature = data.main.temp
        self.humidity = data.main.humidity
        self.windSpeed = data.wind.speed
        
        let description = data.weather.first?.description ?? ""
        let weatherTypeId = data.weather.first?.id ?? 0
        
        self.weather = WeatherType(openWeatherMapId: weatherTypeId, description: description)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        let updatedValuesMap: [String:Any] = [
            "temperature": temperature,
            "humidity": humidity,
            "windSpeed": windSpeed,
            "weather": weather.name,
            "weatherDescription": description,
            "lastUpdated": dateFormatter.string(from: Date())
        ]
        
        let placeReference = Database.database().reference(withPath: "places/" + id)
        placeReference.updateChildValues( updatedValuesMap )
    }
    
    func getNearbyItems() {
        
        let usersReference = Database.database().reference(withPath: "users")
        usersReference.keepSynced(true)
        usersReference.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    
                    var user: User!
                    if let cachedUser = configuration.userCache.object(forKey: childSnapshot.key as NSString) {
                        user = cachedUser
                    } else {
                        user = User(snapshot: childSnapshot)
                    }
                    
                    // Make sure the user is close enough to the current place to display
                    if let distance = user.getDistanceFrom(location: self.location) {
                        if distance <= configuration.maximumItemDistance {
                            
                            if let top = user.clothingItems[.top] {
                                self.nearbyItems.append( (user, top) )
                            }
                            
                            if let bottom = user.clothingItems[.bottom] {
                                self.nearbyItems.append( (user, bottom) )
                            }
                            
                            if let shoes = user.clothingItems[.shoes] {
                                self.nearbyItems.append( (user, shoes) )
                            }
                            
                            if let accessories = user.clothingItems[.accessories] {
                                self.nearbyItems.append( (user, accessories) )
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Place: Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
}


extension Place: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.hashValue)
    }
}
