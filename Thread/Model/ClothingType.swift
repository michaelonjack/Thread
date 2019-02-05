//
//  ClothingType.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation

enum ClothingType: Int {
    case top
    case bottom
    case shoes
    case accessories
    
    var description: String {
        switch self {
        case .top:
            return "Top"
        case .bottom:
            return "Bottom"
        case .shoes:
            return "Shoes"
        case .accessories:
            return "Accessories"
        }
    }
}
