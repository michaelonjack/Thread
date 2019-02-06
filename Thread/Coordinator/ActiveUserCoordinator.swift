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
    
    func logout() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
