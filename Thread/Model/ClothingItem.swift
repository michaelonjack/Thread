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
    var details: String?
    var itemUrl: String?
    var itemImageUrl: String?
    var itemImage: UIImage?
    
    init(snapshot: DataSnapshot, withIdAsKey: Bool = false) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as? String ?? ""
        name = snapshotValue["name"] as? String ?? ""
        brand = snapshotValue["brand"] as? String ?? ""
        itemUrl = snapshotValue["itemUrl"] as? String ?? nil
        itemImageUrl = snapshotValue["itemImageUrl"] as? String ?? nil
        price = snapshotValue["price"] as? Double ?? 0.0
        details = snapshotValue["details"] as? String ?? nil
        
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
    
    init(id:String, type: ClothingType, itemImage: UIImage) {
        self.id = id
        self.type = type
        self.name = ""
        self.price = 0
        self.brand = ""
        self.itemImage = itemImage
    }
    
    func toAnyObject() -> Any {
        var dict: [String:Any] = [
            "id": id,
            "type": type.description,
            "name": name,
            "price": price,
            "brand": brand
        ]
        
        if let itemUrl = itemUrl {
            dict["itemUrl"] = itemUrl
        }
        
        if let itemImageUrl = itemImageUrl {
            dict["itemImageUrl"] = itemImageUrl
        }
        
        if let details = details {
            dict["details"] = details
        }
        
        return dict
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
