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
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersTableView.users = users
        usersTableView.reloadData()
    }
}
