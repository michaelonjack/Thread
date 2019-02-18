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
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationLabel.text = navigationText
        titleLabel.text = titleText

        usersTableView.users = users
        usersTableView.reloadData()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        coordinator?.pop()
    }
}
