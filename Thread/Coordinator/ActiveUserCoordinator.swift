//
//  ActiveUserCoordinator.swift
//  Thread
//
//  Created by Michael Onjack on 2/5/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ActiveUserCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var userId: String
    
    init(userId: String) {
        childCoordinators = []
        navigationController = CoordinatorNavigationController()
        self.userId = userId
    }
    
    func start() {
        let homeController = HomeViewController.instantiate()
        homeController.coordinator = self
        
        navigationController.pushViewController(homeController, animated: false)
    }
    
    func viewSettings() {
        let settingsController = SettingsViewController.instantiate()
        settingsController.coordinator = self
        
        navigationController.pushViewController(settingsController, animated: true)
    }
    
    func viewUserProfile(userId: String) {
        let profileController = UserProfileViewController.instantiate()
        profileController.coordinator = self
        profileController.userId = userId
        
        navigationController.pushViewController(profileController, animated: true)
    }
    
    func viewCloset(forUser user: User, initialIndex: Int = 0) {
        let closetController = ClosetViewController.instantiate()
        closetController.coordinator = self
        closetController.user = user
        closetController.userId = user.uid
        closetController.currentItemIndex = initialIndex
        
        navigationController.pushViewController(closetController, animated: true)
    }
    
    func viewCloset(forUserId userId: String, initialIndex: Int = 0) {
        let closetController = ClosetViewController.instantiate()
        closetController.coordinator = self
        closetController.userId = userId
        closetController.currentItemIndex = initialIndex
        
        navigationController.pushViewController(closetController, animated: true)
    }
    
    func searchClothingItems(forType clothingType: ClothingType) {
        let searchController = ClothingItemSearchViewController.instantiate()
        searchController.coordinator = self
        searchController.clothingType = clothingType
        
        navigationController.pushViewController(searchController, animated: true)
    }
    
    func updateClothingItem(ofType type: ClothingType, existingItem: ClothingItem?) {
        let closetUpdateOptionsController = ClosetUpdateOptionsViewController.instantiate()
        closetUpdateOptionsController.coordinator = self
        closetUpdateOptionsController.clothingType = type
        closetUpdateOptionsController.existingItem = existingItem
        
        navigationController.present(closetUpdateOptionsController, animated: true, completion: nil)
    }
    
    func removeClosetItem(ofType type: ClothingType) {
        configuration.currentUser?.clothingItems[type] = nil
        configuration.currentUser?.save()
        
        let navControllers = navigationController.viewControllers
        
        if let closetController = navControllers[navControllers.count - 1] as? ClosetViewController {
            closetController.user = configuration.currentUser
            closetController.updateViewForNewItem()
            closetController.clothingItemsView.clothingItemCollectionView.reloadItems(at: [IndexPath(row: type.rawValue, section: 0)])
        }
    }
    
    func startEditingDetails(forClothingItem item: ClothingItem) {
        let clothingItemEditController = ClothingItemEditViewController.instantiate()
        clothingItemEditController.coordinator = self
        clothingItemEditController.clothingItem = item
        
        navigationController.pushViewController(clothingItemEditController, animated: true)
    }
    
    func finishEditingDetails(forClothingItem item: ClothingItem) {
        configuration.currentUser?.clothingItems[item.type] = item
        configuration.currentUser?.save()
        
        let navControllers = navigationController.viewControllers
        
        // CASE 1: We're updating the item details via a camera / photo library upload
        if let closetController = navControllers[navControllers.count - 2] as? ClosetViewController {
            closetController.user = configuration.currentUser
            closetController.updateViewForNewItem()
            closetController.clothingItemsView.clothingItemCollectionView.reloadItems(at: [IndexPath(row: item.type.rawValue, section: 0)])
            
            pop()
        }
        
        // CASE 2: We're updating the item details via a ShopStyle product search
        else if let closetController = navControllers[navControllers.count - 3] as? ClosetViewController {
            closetController.user = configuration.currentUser
            closetController.updateViewForNewItem()
            closetController.clothingItemsView.clothingItemCollectionView.reloadItems(at: [IndexPath(row: item.type.rawValue, section: 0)])
            
            pop(to: closetController)
        }
    }
    
    func viewFollowedUsers(users: [User]) {
        let userTableController = UserTableViewController.instantiate()
        userTableController.coordinator = self
        userTableController.users = users
        userTableController.navigationText = "Home"
        userTableController.titleText = "Following"
        
        navigationController.pushViewController(userTableController, animated: true)
    }
    
    func cancelEditingClothingItem() {
        pop()
    }
    
    func logout() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
