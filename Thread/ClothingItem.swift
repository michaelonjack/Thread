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
    var itemPictureUrl: String
    var itemImage: UIImage?
    var isExpanded: Bool
    
    init() {
        self.id = "-1"
        self.name = ""
        self.brand = ""
        self.itemUrl = ""
        self.itemPictureUrl = ""
        
        self.isExpanded = false
        self.price = 0.0
    }
    
    init(id:String, name:String, brand: String, itemUrl:String) {
        self.id = id
        self.name = name
        self.brand = brand
        self.itemUrl = itemUrl
        
        self.itemPictureUrl = ""
        self.isExpanded = false
        self.price = 0.0
    }
    
    init(snapshot: FIRDataSnapshot) {
        id = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        brand = snapshotValue["brand"] as! String
        itemUrl = snapshotValue["link"] as! String
        itemPictureUrl = snapshotValue["pictureUrl"] as! String
        
        self.isExpanded = false
        self.price = 0.0
        
    }
    
    mutating func setItemId(id: String) {
        self.id = id
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
    
    mutating func setItemPictureUrl(url: String) {
        self.itemPictureUrl = url
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "brand": brand,
            "link": itemUrl,
            "pictureUrl": itemPictureUrl
        ]
    }
}
