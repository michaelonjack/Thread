//
//  UserTableViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/17/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserTableViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?

    @IBOutlet weak var usersTableView: UserTableView!
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var navigationText: String!
    var titleText: String!
    
    var userIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationLabel.text = navigationText
        titleLabel.text = titleText
        
        loadUsers()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        coordinator?.pop()
    }
    
    fileprivate func loadUsers() {
        for (i, userId) in userIds.enumerated() {
            getUser(withId: userId) { (user) in
                self.usersTableView.users.append(user)
                
                if i+1 == self.userIds.count {
                    DispatchQueue.main.async {
                        self.usersTableView.reloadData()
                    }
                }
            }
        }
    }
}
