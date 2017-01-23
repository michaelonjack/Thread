//
//  APIKeys.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation

func valueForAPIKey(keyname:String) -> String {
    
    let filePath = Bundle.main.path(forResource: "ApiKeys", ofType:"plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    
    let value:String = plist?.object(forKey: keyname) as! String
    return value
}
