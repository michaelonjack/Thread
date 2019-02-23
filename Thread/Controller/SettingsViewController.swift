//
//  SettingsViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/22/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?

    @IBOutlet weak var settingsTableView: SettingsTableView!
    @IBOutlet weak var navigationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationImage = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysTemplate)
        navigationButton.setImage(navigationImage, for: .normal)
        navigationButton.tintColor = .white

        settingsTableView.delegate = self
    }

    @IBAction func dismissSettings(_ sender: Any) {
        coordinator?.pop()
    }
}



extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowName = settingsTableView.rowData[indexPath.section][indexPath.row].0
        
        switch selectedRowName {
        case "First Name":
            coordinator?.startEditingUserName()
        case "Last Name":
            coordinator?.startEditingUserName()
        case "Email":
            coordinator?.startEditingEmail()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
            headerView.backgroundView = backgroundView
        }
    }
}
