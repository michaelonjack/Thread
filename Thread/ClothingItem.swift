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
    let price: Double
    let brand: String
    let itemUrl: String
    var itemImage: UIImage?
    
    init(name:String, brand: String, itemUrl:String) {
        self.name = name
        self.brand = brand
        self.itemUrl = itemUrl
        
        self.price = 0.0
        self.itemImage = nil
    }
    
    init(name:String, brand: String, itemUrl:String, itemImage:UIImage) {
        self.name = name
        self.brand = brand
        self.itemUrl = itemUrl
        
        self.price = 0.0
        self.itemImage = itemImage
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "brand": brand,
            "link": itemUrl
        ]
    }
}
