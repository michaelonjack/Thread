//
//  ClothingItem.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation

struct ClothingItem {
    let name: String
    let type: ClothingType
    let price: Double
    let brand: String
    let itemUrl: String
    let pictureUrl: String
    
    init(name:String, type: ClothingType, brand: String, itemUrl:String) {
        self.name = name
        self.type = type
        self.brand = brand
        self.itemUrl = itemUrl
        
        self.price = 0.0
        self.pictureUrl = ""
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "brand": brand,
            "link": itemUrl
        ]
    }
}
