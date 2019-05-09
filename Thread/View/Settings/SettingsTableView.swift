//
//  SettingsTableView.swift
//  Thread
//
//  Created by Michael Onjack on 2/22/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsTableView: UITableView {
    
    let sectionTitles = ["ACCOUNT", "ACCOUNT ACTIONS", "INFORMATION"]
    var rowData = [
        [("First Name", ""), ("Last Name", ""), ("Email", ""), ("Profile Picture", "")],
        [("Logout", ""), ("Change Password", "")],
        [("Terms of Service", ""), ("Privacy Policy", ""),("Contact", "")]
    ]
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        dataSource = self
        
        register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 44.0
        tintColor = .white
        
        loadInitialValues()
    }
    
    fileprivate func loadInitialValues() {
        guard let currentUser = configuration.currentUser else { return }
        
        rowData[0][0].1 = currentUser.firstName
        rowData[0][1].1 = currentUser.lastName
        rowData[0][2].1 = currentUser.email
    }
}



extension SettingsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        guard let settingsCell = cell as? SettingsTableViewCell else { return cell }
        
        let currentRowData = rowData[indexPath.section][indexPath.row]
        settingsCell.nameLabel.text = currentRowData.0
        settingsCell.valueLabel.text = currentRowData.1
        settingsCell.selectionStyle = .none
        
        return settingsCell
    }
}
