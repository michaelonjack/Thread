//
//  MainCoordinator.swift
//  Thread
//
//  Created by Michael Onjack on 2/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginController: LoginViewController = LoginViewController.instantiate()
        loginController.coordinator = self
        navigationController.pushViewController(loginController, animated: false)
    }
    
    func login() {
        if let currentUser = Auth.auth().currentUser {
            let activeUserCoordinator = ActiveUserCoordinator(userId: currentUser.uid)
            childCoordinators.append(activeUserCoordinator)
            activeUserCoordinator.start()
            
            navigationController.present(activeUserCoordinator.navigationController, animated: true)
        }
    }
    
    func attemptAutoLogin() {
        if let currentUser = Auth.auth().currentUser {
            let activeUserCoordinator = ActiveUserCoordinator(userId: currentUser.uid)
            childCoordinators.append(activeUserCoordinator)
            activeUserCoordinator.start()
            
            let launchScreenView = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()!.view!
            launchScreenView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            launchScreenView.frame = navigationController.view.frame
            navigationController.view.addSubview(launchScreenView)
            
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.navigationController.present(activeUserCoordinator.navigationController, animated: false, completion: {
                        launchScreenView.removeFromSuperview()
                    })
                }
            }
        }
    }
}
