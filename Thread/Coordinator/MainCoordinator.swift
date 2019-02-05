//
//  MainCoordinator.swift
//  Thread
//
//  Created by Michael Onjack on 2/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileController = UserProfileViewController.instantiate()
        profileController.coordinator = self
        profileController.userId = Auth.auth().currentUser?.uid
        
        navigationController.pushViewController(profileController, animated: false)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func viewCloset(forUser user: User) {
        let closetController = ClosetViewController.instantiate()
        closetController.coordinator = self
        closetController.user = user
        closetController.userId = user.uid
        
        navigationController.pushViewController(closetController, animated: true)
    }
    
    func viewCloset(forUserId userId: String) {
        let closetController = ClosetViewController.instantiate()
        closetController.coordinator = self
        closetController.userId = userId
        
        navigationController.pushViewController(closetController, animated: true)
    }
}
