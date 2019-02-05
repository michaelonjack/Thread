//
//  CoordinatorNavigationController.swift
//  Thread
//
//  Created by Michael Onjack on 2/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class CoordinatorNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension CoordinatorNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
