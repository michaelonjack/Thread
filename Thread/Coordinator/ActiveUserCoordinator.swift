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
        let profileController = UserProfileViewController.instantiate()
        profileController.coordinator = self
        profileController.userId = Auth.auth().currentUser?.uid
        
        navigationController.pushViewController(profileController, animated: false)
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
    
    func updateClothingItem(ofType type: ClothingType) {
        let closetUpdateOptionsController = ClosetUpdateOptionsViewController.instantiate()
        closetUpdateOptionsController.coordinator = self
        closetUpdateOptionsController.clothingType = type
        
        navigationController.present(closetUpdateOptionsController, animated: true, completion: nil)
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
        if let closetController = navControllers[navControllers.count - 2] as? ClosetViewController {
            closetController.user = configuration.currentUser
            closetController.updateViewForNewItem()
            closetController.clothingItemsView.clothingItemCollectionView.reloadItems(at: [IndexPath(row: item.type.rawValue, section: 0)])
        }
        
        pop()
    }
    
    func cancelEditingClothingItem() {
        pop()
    }
    
    func logout() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}