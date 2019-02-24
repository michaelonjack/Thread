//
//  Place.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase
import SDWebImage

class Place {
    let id: String
    let name: String
    let blurb: String
    var location: CLLocation?
    var image: UIImage?
    var imageUrls: [URL] = []
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        id = snapshot.key
        name = snapshotValue["name"] as? String ?? ""
        blurb = snapshotValue["blurb"] as? String ?? ""
        
        let imagesSnapshot = snapshot.childSnapshot(forPath: "imageUrls")
        for childSnapshot in imagesSnapshot.children {
            let imageUrlSnapshot = childSnapshot as! DataSnapshot
            if let imageUrlStr = imageUrlSnapshot.value as? String, let imageUrl = URL(string: imageUrlStr) {
                imageUrls.append(imageUrl)
            }
        }
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        if let image = image {
            completion(image)
            return
        }
        
        SDWebImageDownloader.shared().downloadImage(with: imageUrls[0], options: .init(rawValue: 0), progress: nil) { (image, _, error, _) in
            if error != nil {
                completion(nil)
                return
            }
            
            self.image = image
            completion(image)
            return
        }
    }
}
