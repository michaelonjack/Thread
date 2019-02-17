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
import SDWebImage

enum ImageSize {
    case small
    case normal
}

struct ClothingItem {
    var id: String
    var type: ClothingType
    var name: String
    var brand: String
    var price: Double?
    var details: String?
    var itemUrl: String?
    var itemImageUrl: String?
    var smallItemImageUrl: String?
    var itemImage: UIImage?
    var smallItemImage: UIImage?
    
    init(snapshot: DataSnapshot, withIdAsKey: Bool = false) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as? String ?? ""
        name = snapshotValue["name"] as? String ?? ""
        brand = snapshotValue["brand"] as? String ?? ""
        itemUrl = snapshotValue["itemUrl"] as? String ?? nil
        itemImageUrl = snapshotValue["itemImageUrl"] as? String ?? nil
        smallItemImageUrl = snapshotValue["smallItemImageUrl"] as? String ?? nil
        price = snapshotValue["price"] as? Double ?? nil
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
        self.brand = ""
        self.itemImage = itemImage
    }
    
    init(shopStyleItem: ShopStyleClothingItem, clothingType: ClothingType) {
        self.id = String(shopStyleItem.id)
        self.type = clothingType
        self.name = shopStyleItem.unbrandedName
        self.price = shopStyleItem.price
        self.brand = shopStyleItem.brand?.name ?? ""
        self.details = shopStyleItem.description
        self.itemUrl = shopStyleItem.clickUrl
        self.itemImageUrl = shopStyleItem.image.sizes["Best"]?.url
        self.smallItemImageUrl = shopStyleItem.image.sizes["IPhone"]?.url
    }
    
    func toAnyObject() -> Any {
        var dict: [String:Any] = [
            "id": id,
            "type": type.description,
            "name": name,
            "brand": brand
        ]
        
        if let price = price {
            dict["price"] = price
        }
        
        if let itemUrl = itemUrl {
            dict["itemUrl"] = itemUrl
        }
        
        if let itemImageUrl = itemImageUrl {
            dict["itemImageUrl"] = itemImageUrl
        }
        
        if let smallItemImageUrl = smallItemImageUrl {
            dict["smallItemImageUrl"] = smallItemImageUrl
        }
        
        if let details = details {
            dict["details"] = details
        }
        
        return dict
    }
    
    func getImage(ofPreferredSize size: ImageSize, completion: @escaping (UIImage?) -> Void) {
        switch size {
        case .small:
            if let smallImage = smallItemImage {
                completion(smallImage)
                return
            }
            
            else if let imageUrlStr = smallItemImageUrl, let imageUrl = URL(string: imageUrlStr) {
                SDWebImageDownloader.shared().downloadImage(with: imageUrl, options: SDWebImageDownloaderOptions.init(rawValue: 0), progress: nil) { (image, _, error, _) in
                    if error != nil {
                        completion(nil)
                        return
                    }
                    
                    completion(image)
                    return
                }
            }
            fallthrough
        case .normal:
            if let normalImage = itemImage {
                completion(normalImage)
            }
            
            else if let imageUrlStr = itemImageUrl, let imageUrl = URL(string: imageUrlStr) {
                SDWebImageDownloader.shared().downloadImage(with: imageUrl, options: SDWebImageDownloaderOptions.init(rawValue: 0), progress: nil) { (image, _, error, _) in
                    if error != nil {
                        completion(nil)
                        return
                    }
                    
                    completion(image)
                    return
                }
            }
            
            else {
                completion(nil)
            }
        }
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
