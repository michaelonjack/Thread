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
    let id: Double
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

struct APIHelper {
    
    static func valueForAPIKey(keyname:String) -> String? {
        
        let filePath = Bundle.main.path(forResource: "APIKeys", ofType:"plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        
        return plist?.object(forKey: keyname) as? String
    }
    
    
    
    static func searchShopStyle(query: String, limit: Int = 40, completion: @escaping (([ClothingItem], Error?) -> Void)) {
        
        guard let shopStyleAPIKey = valueForAPIKey(keyname: "ShopStyle") else { return }
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        var urlStr = "https://api.shopstyle.com/api/v2/products?"
        urlStr = urlStr + "pid=" + shopStyleAPIKey
        urlStr = urlStr + "&limit=" + String(limit)
        urlStr = urlStr + "&fts=" + encodedQuery
        
        var searchResults: [ClothingItem] = []
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    completion(searchResults, error)
                    return
                }
                
                guard let data = data else {
                    completion(searchResults, nil)
                    return
                }
                
                do {
                    let jsonData = try JSONDecoder().decode(ShopStyleRoot.self, from: data)
                    
                    searchResults = jsonData.products.map { ClothingItem(shopStyleItem: $0) }
                    
                    completion(searchResults, nil)
                    
                } catch let jsonError {
                    completion(searchResults, jsonError)
                    return
                }
            }.resume()
        } else {
            completion(searchResults, nil)
            return
        }
    }
}
