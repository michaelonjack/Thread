//
//  ClothingType.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation

enum ClothingType {
    case Top
    case Bottom
    case Shoes
    case Accessories
    
    var description:String {
        switch self {
        case .Top:
            return "Top"
        case .Bottom:
            return "Bottom"
        case .Shoes:
            return "Shoes"
        case .Accessories:
            return "Accessories"
        }
    }
}
