//
//  DatabaseHelper.swift
//  Thread
//
//  Created by Michael Onjack on 6/24/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation
import FirebaseStorage


func getDataForUser(userid:String, completion: @escaping ([String:AnyObject]) -> ()) {
    
    Database.database().reference(withPath: "users/" + userid).observeSingleEvent(of: .value, with: { (snapshot) in
        let userData = snapshot.value as! [String:AnyObject]
        completion(userData)
    })
}
