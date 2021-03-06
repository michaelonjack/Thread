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
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
            configuration.currentUser = nil
            navigationController.dismiss(animated: true, completion: nil)
        } catch {
            print("error signing out")
        }
    }
    
    func viewSettings() {
        let settingsController = SettingsViewController.instantiate()
        settingsController.coordinator = self
        
        navigationController.pushViewController(settingsController, animated: true)
    }
    
    func startEditingUserName() {
        let settingsNameController = SettingsNameViewController()
        settingsNameController.coordinator = self
        
        navigationController.pushViewController(settingsNameController, animated: true)
    }
    
    func finishEditingUserName(firstName: String, lastName: String) {
        configuration.currentUser?.firstName = firstName
        configuration.currentUser?.lastName = lastName
        configuration.currentUser?.save()
        
        let navControllers = navigationController.viewControllers
        
        guard let settingsController = navControllers[navControllers.count - 2] as? SettingsViewController else { return }
        
        settingsController.settingsTableView.rowData[0][0].1 = firstName
        settingsController.settingsTableView.rowData[0][1].1 = lastName
        settingsController.settingsTableView.reloadData()
        
        pop()
    }
    
    func startEditingEmail() {
        let settingsEmailController = SettingsEmailViewController()
        settingsEmailController.coordinator = self
        
        navigationController.pushViewController(settingsEmailController, animated: true)
    }
    
    func finishEditingEmail(email: String) {
        let navControllers = navigationController.viewControllers
        
        guard let settingsEmailController = navControllers[navControllers.count - 1] as? SettingsEmailViewController else { return }
        guard let settingsController = navControllers[navControllers.count - 2] as? SettingsViewController else { return }
        
        DispatchQueue.main.async {
            settingsEmailController.updateResultLabel.text = "Checking..."
        }
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if error == nil {
                configuration.currentUser?.email = email
                configuration.currentUser?.save()
                
                settingsController.settingsTableView.rowData[0][2].1 = email
                settingsController.settingsTableView.reloadData()
                
                self.pop()
            }
            
            else {
                DispatchQueue.main.async {
                    settingsEmailController.updateResultLabel.text = error?.localizedDescription
                }
            }
        })
    }
    
    func finishEditingPassword(currentPassword: String, newPassword: String, confirmPassword: String) {
        let navControllers = navigationController.viewControllers
        
        guard let settingsPasswordController = navControllers[navControllers.count - 1] as? SettingsPasswordViewController else { return }
        guard let firebaseUser = Auth.auth().currentUser else { return }
        
        let credential = EmailAuthProvider.credential(withEmail: firebaseUser.email!, password: currentPassword)
        
        firebaseUser.reauthenticate(with: credential) { (result, error) in
            if error != nil {
                DispatchQueue.main.async {
                    settingsPasswordController.updateResultLabel.text = error?.localizedDescription
                }
                return
            }
            
            firebaseUser.updatePassword(to: newPassword, completion: { (error) in
                if error != nil {
                    DispatchQueue.main.async {
                        settingsPasswordController.updateResultLabel.text = error?.localizedDescription
                    }
                    return
                }
                
                self.pop()
            })
        }
    }
    
    func startEditingPassword() {
        let settingsPasswordController = SettingsPasswordViewController()
        settingsPasswordController.coordinator = self
        
        navigationController.pushViewController(settingsPasswordController, animated: true)
    }
    
    func viewPrivacyPolicy() {
        let policyController = SettingsPolicyViewController()
        policyController.coordinator = self
        
        navigationController.pushViewController(policyController, animated: true)
    }
    
    func viewTermsOfService() {
        let termsController = SettingsTermsViewController()
        termsController.coordinator = self
        
        navigationController.pushViewController(termsController, animated: true)
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
    
    func startEditingDetails(forClothingItem item: ClothingItem, updateItemImage: Bool = true) {
        let clothingItemEditController = ClothingItemEditViewController.instantiate()
        clothingItemEditController.coordinator = self
        clothingItemEditController.clothingItem = item
        clothingItemEditController.itemImageUpdated = updateItemImage
        
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
    
    func viewFollowedUsers(for user: User) {
        let userTableController = UserTableViewController.instantiate()
        userTableController.coordinator = self
        userTableController.userIds = user.followingUserIds
        userTableController.navigationText = "Home"
        userTableController.titleText = "Following"
        
        navigationController.pushViewController(userTableController, animated: true)
    }
    
    func viewFavoritedItems(for user: User) {
        let itemsTableController = ClothingItemTableViewController.instantiate()
        itemsTableController.coordinator = self
        itemsTableController.clothingItems = user.favoritedItems
        itemsTableController.navigationText = "Home"
        itemsTableController.titleText = "Favorites"
        
        navigationController.pushViewController(itemsTableController, animated: true)
    }
    
    func viewLocation(location: Place) {
        let locationController = LocationViewController.instantiate()
        locationController.coordinator = self
        locationController.location = location
        
        navigationController.pushViewController(locationController, animated: true)
    }
    
    func cancelEditingClothingItem() {
        pop()
    }
}
