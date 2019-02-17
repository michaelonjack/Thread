//
//  SlideOutMenuDelegate.swift
//  Thread
//
//  Created by Michael Onjack on 2/16/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation

protocol SlideOutMenuDelegate: class {
    func didSelectProfileOption()
    func didSelectFollowingOption()
    func didSelectFavoritesOption()
    func didSelectSettingsOption()
}
