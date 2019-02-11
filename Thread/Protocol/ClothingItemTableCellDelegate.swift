//
//  ClothingItemTableCellDelegate.swift
//  Thread
//
//  Created by Michael Onjack on 2/10/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation

protocol ClothingItemTableCellDelegate: AnyObject {
    func viewClothingItem(at cell: ClothingItemTableViewCell)
    func selectClothingItem(at cell: ClothingItemTableViewCell)
}
