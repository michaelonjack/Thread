//
//  APIKeys.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation

struct ShopStyleRoot: Decodable {
    let products: [ShopStyleClothingItem]
}

struct ShopStyleClothingItem: Decodable {
    let id: Int
    let brandedName: String
    let unbrandedName: String
    let description: String
    let clickUrl: String
    let price: Double
    let brand: ShopStyleBrand?
    let categories: [ShopStyleCategory]
    let image: ShopStyleImageDict
}

struct ShopStyleBrand: Decodable {
    let id: String
    let name: String
}

struct ShopStyleCategory: Decodable {
    let id: String
    let name: String
    let shortName: String
    let fullName: String
}

struct ShopStyleImageDict: Decodable {
    let sizes: [String: ShopStyleImage]
}

struct ShopStyleImage: Decodable {
    let sizeName: String
    let url: String
    let width: Int?
    let height: Int?
    let actualWidth: Int?
    let actualHeight: Int?
}


struct OpenWeatherMapData: Decodable {
    let coord: OpenWeatherCoordinateData
    let main: OpenWeatherBasicData
    var wind: OpenWeatherWindData
    let weather: [OpenWeatherType]
}

struct OpenWeatherCoordinateData: Decodable {
    let lon: Double
    let lat: Double
}

struct OpenWeatherBasicData: Decodable {
    let temp: Double
    let pressure: Double
    let humidity: Double
}

struct OpenWeatherType: Decodable {
    let id: Int
    let main: String
    let description: String
}

struct OpenWeatherWindData: Decodable {
    let speed: Double
}

struct APIHelper {
    
    static func valueForAPIKey(keyname:String) -> String? {
        
        let filePath = Bundle.main.path(forResource: "APIKeys", ofType:"plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        
        return plist?.object(forKey: keyname) as? String
    }
    
    
    
    static func searchShopStyle(query: String, limit: Int = 40, completion: @escaping (([ShopStyleClothingItem], Error?) -> Void)) {
        
        guard let shopStyleAPIKey = valueForAPIKey(keyname: "ShopStyle") else { return }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        var urlStr = "https://api.shopstyle.com/api/v2/products?"
        urlStr = urlStr + "pid=" + shopStyleAPIKey
        urlStr = urlStr + "&limit=" + String(limit)
        urlStr = urlStr + "&fts=" + encodedQuery
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    completion([ShopStyleClothingItem](), error)
                    return
                }
                
                guard let data = data else {
                    completion([ShopStyleClothingItem](), nil)
                    return
                }
                
                do {
                    let jsonData = try JSONDecoder().decode(ShopStyleRoot.self, from: data)
                    
                    completion(jsonData.products, nil)
                    
                } catch let jsonError {
                    completion([ShopStyleClothingItem](), jsonError)
                    return
                }
            }.resume()
        } else {
            completion([ShopStyleClothingItem](), nil)
            return
        }
    }
    
    
    
    static func getCurrentWeather(for place: Place, completion: @escaping ((OpenWeatherMapData?, Error?) -> Void)) {
        guard let openWeatherMapAPIKey = valueForAPIKey(keyname: "OpenWeatherMap") else { return }
        
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?appid=" + openWeatherMapAPIKey + "&zip=" + place.zip + "&units=imperial"
        
        guard let url = URL(string: urlStr) else {
            print("invalid url!!!!")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if(error != nil) {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("data is nil")
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(OpenWeatherMapData.self, from: data)
                completion(jsonData, nil)
                return
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
}
