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
    let zip: String
    var weather: WeatherType
    var temperature: Double
    var humidity: Double
    var windSpeed: Double
    var location: CLLocation?
    var image: UIImage?
    var imageUrls: [URL] = []
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        id = snapshot.key
        name = snapshotValue["name"] as? String ?? ""
        blurb = snapshotValue["blurb"] as? String ?? ""
        zip = snapshotValue["zip"] as? String ?? ""
        temperature = snapshotValue["temperature"] as? Double ?? 0.0
        humidity = snapshotValue["humidity"] as? Double ?? 0.0
        windSpeed = snapshotValue["windSpeed"] as? Double ?? 0.0
        
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
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        if let image = image {
            completion(image)
            return
        }
        
        SDWebImageDownloader.shared().downloadImage(with: imageUrls[0], options: .init(rawValue: 0), progress: nil) { (image, _, error, _) in
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
        
        let updatedValuesMap: [String:Any] = [
            "temperature": temperature,
            "humidity": humidity,
            "windSpeed": windSpeed,
            "weather": weather.name,
            "weatherDescription": description
        ]
        
        let placeReference = Database.database().reference(withPath: "places/" + id)
        placeReference.updateChildValues( updatedValuesMap )
    }
}
