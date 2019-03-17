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

class ClothingItem {
    var id: String
    var type: ClothingType
    var name: String
    var brand: String
    var price: Double?
    var details: String?
    var itemUrl: URL?
    var itemImageUrl: URL?
    var smallItemImageUrl: URL?
    var itemImage: UIImage?
    var smallItemImage: UIImage?
    var tags: [String] = []
    
    init(snapshot: DataSnapshot, withIdAsKey: Bool = false) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as? String ?? ""
        name = snapshotValue["name"] as? String ?? ""
        brand = snapshotValue["brand"] as? String ?? ""
        price = snapshotValue["price"] as? Double ?? nil
        details = snapshotValue["details"] as? String ?? nil
        
        let tagsSnapshot = snapshot.childSnapshot(forPath: "tags")
        for child in tagsSnapshot.children {
            let childSnapshot = child as! DataSnapshot
            let tag = childSnapshot.value as? String ?? ""
            tags.append(tag)
        }
        
        if let itemUrlStr = snapshotValue["itemUrl"] as? String {
            itemUrl = URL(string: itemUrlStr)
        }
        
        if let itemImageUrlStr = snapshotValue["itemImageUrl"] as? String {
            itemImageUrl = URL(string: itemImageUrlStr)
        }
        
        if let smallItemImageUrlStr = snapshotValue["smallItemImageUrl"] as? String {
            smallItemImageUrl = URL(string: smallItemImageUrlStr)
        }
        
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
        self.itemUrl = URL(string: shopStyleItem.clickUrl)
        
        if let itemImageUrlStr = shopStyleItem.image.sizes["Best"]?.url {
            itemImageUrl = URL(string: itemImageUrlStr)
        }
        
        if let smallItemImageUrlStr = shopStyleItem.image.sizes["IPhone"]?.url {
            smallItemImageUrl = URL(string: smallItemImageUrlStr)
        }
    }
    
    func toAnyObject() -> Any {
        
        var tagsDict: [String:Any] = [:]
        for tag in tags {
            tagsDict[UUID().uuidString] = tag
        }
        
        var dict: [String:Any] = [
            "id": id,
            "type": type.description,
            "name": name,
            "brand": brand,
            "tags": tagsDict
        ]
        
        if let price = price {
            dict["price"] = price
        }
        
        if let itemUrl = itemUrl {
            dict["itemUrl"] = itemUrl.absoluteString
        }
        
        if let itemImageUrl = itemImageUrl {
            dict["itemImageUrl"] = itemImageUrl.absoluteString
        }
        
        if let smallItemImageUrl = smallItemImageUrl {
            dict["smallItemImageUrl"] = smallItemImageUrl.absoluteString
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
            
            else if let imageUrl = smallItemImageUrl {
                SDWebImageDownloader.shared().downloadImage(with: imageUrl, options: SDWebImageDownloaderOptions.init(rawValue: 0), progress: nil) { (image, _, error, _) in
                    if error != nil {
                        completion(nil)
                        return
                    }
                    
                    self.smallItemImage = image
                    completion(image)
                    return
                }
            }
            fallthrough
        case .normal:
            if let normalImage = itemImage {
                completion(normalImage)
            }
            
            else if let imageUrl = itemImageUrl {
                SDWebImageDownloader.shared().downloadImage(with: imageUrl, options: SDWebImageDownloaderOptions.init(rawValue: 0), progress: nil) { (image, _, error, _) in
                    if error != nil {
                        completion(nil)
                        return
                    }
                    
                    self.itemImage = image
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
