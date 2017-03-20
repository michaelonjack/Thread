//
//  SettingsViewController.swift
//  Thread
//
//  Created by Michael Onjack on 3/11/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableViewSettings: UITableView!
    
    let currentUserRef = FIRDatabase.database().reference(withPath: "users/" + (FIRAuth.auth()?.currentUser?.uid)!)
    let currentUser = FIRAuth.auth()?.currentUser
    let threadKeychainWrapper = KeychainWrapper()
    
    // Can't use dict because we need to obey this ordering
    var settings: [(key: String, value: String)] = [
        ("ACCOUNT", "header"),
        ("First Name", ""),
        ("Last Name", ""),
        ("Email", ""),
        ("Birthday", ""),
        ("Password", "***"),
        ("ACCOUNT ACTIONS", "header"),
        ("Logout", ">"),
        ("SUPPORT", "header"),
        ("Contact/Request", "mikeonjack@gmail.com")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the font of the navigation bar's header
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Avenir-Book", size: 20)!,
            NSForegroundColorAttributeName: UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
        ]
        
        tableViewSettings.delegate = self
        tableViewSettings.dataSource = self
        
        tableViewSettings.rowHeight = UITableViewAutomaticDimension
        tableViewSettings.estimatedRowHeight = 100
        
        loadProfileData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // loadProfileData
    //
    //  Pulls the user's profile picture from the database if it exists
    //
    func loadProfileData() {
        // Load the stored image
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let storedData = snapshot.value as? NSDictionary
            
            self.settings[1].value = storedData?["firstName"] as? String ?? ""
            self.settings[2].value = storedData?["lastName"] as? String ?? ""
            self.settings[3].value = storedData?["email"] as? String ?? ""
            self.settings[4].value = storedData?["birthday"] as? String ?? ""
            
            DispatchQueue.main.async {
                self.tableViewSettings.reloadData()
            }
        })
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // tableView -- numberOfRowsInSection
    //
    //  Returns the number of rows in the table (uses the clothingSearchResults array as data source)
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- cellForRowAt
    //
    //  Determines what information is to be displayed in each table cell
    //  Uses the ClothingItem at the matching index of clothingSearchResults to set the cell's information
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsTableViewCell
        
        // Convoluted way of making sure the table only loads once so the 'header' rows don't get dequeued and reused as "non-header" rows
        if self.settings[1].value != "" {
            let currentKey = settings[indexPath.row].key
            let currentValue = settings[indexPath.row].value
            
            if settings[indexPath.row].value != "header" {
                
                if currentKey == "Password" {
                    cell.textFieldValue.isSecureTextEntry = true
                } else if currentKey == "Logout" || currentKey == "Contact/Request" {
                    cell.textFieldValue.isUserInteractionEnabled = false
                }
                
                cell.labelKey.text = currentKey
                cell.textFieldValue.text = currentValue
            }
            else {
                cell.labelKey.text = currentKey
                cell.labelKey.textColor = UIColor.white
                cell.textFieldValue.text = ""
                cell.textFieldValue.isUserInteractionEnabled = false
                cell.backgroundColor = UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
            }
        }
        
        return cell
    }
    
    
    @IBAction func settingChanged(_ sender: UITextField) {
        let parentCell = sender.superview?.superview! as! SettingsTableViewCell
        
        switch parentCell.labelKey.text! {
            case "First Name":
                currentUserRef.updateChildValues(["firstName": parentCell.textFieldValue.text ?? ""])
            case "Last Name":
                currentUserRef.updateChildValues(["lastName": parentCell.textFieldValue.text ?? ""])
            case "Email":
                if let newEmail = parentCell.textFieldValue.text {
                    currentUser?.updateEmail(newEmail, completion: { (error) in
                        if error == nil {
                            self.currentUserRef.updateChildValues(["email": newEmail])
                            
                            // Update the email in the keychain
                            UserDefaults.standard.setValue(newEmail, forKey: "userEmail")
                        } else {
                            let errorAlert = UIAlertController(title: "Error",
                                                               message: error?.localizedDescription,
                                                               preferredStyle: .alert)
                            
                            let okayAction = UIAlertAction(title: "Close", style: .default)
                            errorAlert.addAction(okayAction)
                            self.present(errorAlert, animated: true, completion:nil)
                        }
                    })
                }
            case "Birthday":
                currentUserRef.updateChildValues(["birthday": parentCell.textFieldValue.text ?? ""])
            case "Password":
                if let newPassword = parentCell.textFieldValue.text {
                    currentUser?.updatePassword(newPassword, completion: { (error) in
                        if error == nil {
                            // Update password in keychain
                            self.threadKeychainWrapper.mySetObject(newPassword, forKey:kSecValueData)
                            self.threadKeychainWrapper.writeToKeychain()
                            UserDefaults.standard.synchronize()
                        } else {
                            let errorAlert = UIAlertController(title: "Error",
                                                               message: error?.localizedDescription,
                                                               preferredStyle: .alert)
                            
                            let okayAction = UIAlertAction(title: "Close", style: .default)
                            errorAlert.addAction(okayAction)
                            self.present(errorAlert, animated: true, completion:nil)
                        }
                    })
                }
            default:
                var _ = 0
        }
    }
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- canEditRowAt
    //
    //  Determines if the cell can be edited (No cells in this table are editable)
    //
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- didSelectRowAt
    //
    //  Segues the selected clothing item back to the user's profile and occupies the view with its data
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
