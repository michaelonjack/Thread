//
//  ClothingItemTag.swift
//  Thread
//
//  Created by Michael Onjack on 4/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ClothingItemTag {
    let id: String
    let name: String
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
    
    init(snapshot: DataSnapshot) {
        id = snapshot.key
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as? String ?? ""
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
        ]
    }
}
