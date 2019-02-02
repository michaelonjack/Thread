//
//  Configuration.swift
//  Thread
//
//  Created by Michael Onjack on 2/2/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation

final class Configuration {
    private static let sharedConfiguration: Configuration = Configuration()
    
    private init() {
        
    }
    
    class func shared() -> Configuration {
        return sharedConfiguration
    }
}
