//
//  Coordinator.swift
//  Thread
//
//  Created by Michael Onjack on 2/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
