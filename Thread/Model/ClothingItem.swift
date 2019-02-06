//
//  ClothingItem.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct ClothingItem {
    var id: String
    var type: ClothingType
    var name: String
    var price: Double
    var brand: String
    var itemUrl: String
    var itemImageUrl: String
    var itemImage: UIImage?
    
    init(id: String, type: ClothingType, name: String, brand: String, itemUrl: String) {
        self.id = id
        self.type = type
        self.name = name
        self.brand = brand
        self.itemUrl = itemUrl
        
        self.itemImageUrl = ""
        self.price = 0.0
    }
    
    init(snapshot: DataSnapshot, withIdAsKey: Bool = false) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as? String ?? ""
        name = snapshotValue["name"] as? String ?? ""
        brand = snapshotValue["brand"] as? String ?? ""
        itemUrl = snapshotValue["link"] as? String ?? ""
        itemImageUrl = snapshotValue["pictureUrl"] as? String ?? ""
        price = snapshotValue["price"] as? Double ?? 0.0
        
        let itemType = snapshotValue["type"] as? String ?? ""
        let clothingType = withIdAsKey ? itemType : snapshot.key
        switch clothingType {
        case ClothingType.bottom.description:
            type = .bottom
        case ClothingType.shoes.description:
            type = .shoes
        case ClothingType.accessories.description:
            type = .accessories
        default:
            type = .top
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "type": type.description,
            "name": name,
            "price": price,
            "brand": brand,
            "itemUrl": itemUrl,
            "itemImageUrl": itemImageUrl
        ]
    }
}

extension ClothingItem: Equatable {
    static func == (lhs: ClothingItem, rhs: ClothingItem) -> Bool {
        return lhs.id == rhs.id
    }
}


extension ClothingItem: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
}
