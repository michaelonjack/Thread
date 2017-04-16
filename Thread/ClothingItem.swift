//
//  ClothingItem.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation

struct ClothingItem {
    var id: String
    var name: String
    var price: Double
    var brand: String
    var itemUrl: String
    var itemImage: UIImage?
    var isExpanded: Bool
    
    init() {
        self.id = "-1"
        self.name = ""
        self.brand = ""
        self.itemUrl = ""
        
        self.isExpanded = false
        self.price = 0.0
        self.itemImage = nil
    }
    
    init(id:String, name:String, brand: String, itemUrl:String) {
        self.id = id
        self.name = name
        self.brand = brand
        self.itemUrl = itemUrl
        
        self.isExpanded = false
        self.price = 0.0
        self.itemImage = nil
    }
    
    init(id: String, name:String, brand: String, itemUrl:String, itemImage:UIImage) {
        self.id = id
        self.name = name
        self.brand = brand
        self.itemUrl = itemUrl
        
        self.isExpanded = false
        self.price = 0.0
        self.itemImage = itemImage
    }
    
    mutating func setName(name:String) {
        self.name = name
    }
    
    mutating func setBrand(brand: String) {
        self.brand = brand
    }
    
    mutating func setItemUrl(url: String) {
        self.itemUrl = url
    }
    
    mutating func setItemId(id: String) {
        self.id = id
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "brand": brand,
            "link": itemUrl
        ]
    }
}
