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
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    let currentUser = Auth.auth().currentUser
    let threadKeychainWrapper = KeychainWrapper()
    
    let sections = ["ACCOUNT", "ACCOUNT ACTIONS", "SUPPORT"]
    var items = [
            [("First Name", ""), ("Last Name", ""), ("Email", ""), ("Birthday", "")],
            [("Logout", ">"), ("Change Password", ">")],
            [("Contact/Requests", "thethreadapplication@gmail.com")]
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the font of the navigation bar's header
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
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
    
    @IBAction func returnToCenterPressed(_ sender: Any) {
        self.containerSwipeNavigationController?.showEmbeddedView(position: .center)
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
            
            self.items[0][0].1 = storedData?["firstName"] as? String ?? ""
            self.items[0][1].1 = storedData?["lastName"] as? String ?? ""
            self.items[0][2].1 = storedData?["email"] as? String ?? ""
            self.items[0][3].1 = storedData?["birthday"] as? String ?? ""
            self.items[0][3].1 += " >"
            
            DispatchQueue.main.async {
                self.tableViewSettings.reloadData()
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width, height: 25))
        label.text = self.sections[section]
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir-Book", size: 15)!
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // tableView -- numberOfRowsInSection
    //
    //  Returns the number of rows in the table (uses the clothingSearchResults array as data source)
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  tableView -- cellForRowAt
    //
    //  Determines what information is to be displayed in each table cell
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsTableViewCell
        let currentKey = self.items[indexPath.section][indexPath.row].0
        let currentValue = self.items[indexPath.section][indexPath.row].1
        
        cell.labelKey.text = currentKey
        cell.textFieldValue.text = currentValue
        
        let readOnly = ["Birthday", "Change Password", "Logout", "Contact/Requests"]
        if readOnly.contains(currentKey) {
            cell.textFieldValue.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  settingsChanged
    //
    //
    //
    @IBAction func settingChanged(_ sender: UITextField) {
        let parentCell = sender.superview?.superview! as! SettingsTableViewCell
        
        switch parentCell.labelKey.text! {
            case "First Name":
                currentUserRef.updateChildValues(["firstName": parentCell.textFieldValue.text ?? ""])
            case "Last Name":
                currentUserRef.updateChildValues(["lastName": parentCell.textFieldValue.text ?? ""])
            case "Email":
                if let newEmail = parentCell.textFieldValue.text {
                    currentUser?.updateEmail(to: newEmail, completion: { (error) in
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
            case "Password":
                if let newPassword = parentCell.textFieldValue.text {
                    currentUser?.updatePassword(to: newPassword, completion: { (error) in
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
    //
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentKey = self.items[indexPath.section][indexPath.row].0
        
        switch currentKey {
            case "Logout":
                do {
                    try Auth.auth().signOut()
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {break}
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    appDelegate.window?.rootViewController = loginViewController
                } catch {
                    print("Sign out failure")
            }
            
            case "Birthday":
                self.performSegue(withIdentifier: "SettingsToDatePicker", sender: nil)
            
            case "Change Password":
                self.performSegue(withIdentifier: "SettingsToPassword", sender: nil)
            
            default:
                var _ = 0
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "SettingsToDatePicker":
            let dateVC: DatePickerViewController = segue.destination as! DatePickerViewController
            dateVC.presentingVC = self
            
            var birthdayStr = self.items[0][3].1
            let index = birthdayStr.index(birthdayStr.startIndex, offsetBy: birthdayStr.characters.count-2)
            birthdayStr = birthdayStr.substring(to: index)
            dateVC.birthdayStr = birthdayStr
            
            if birthdayStr != "" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                let birthdayDate = dateFormatter.date(from: birthdayStr)
                
                dateVC.birthdayDate = birthdayDate!
            }
            
        default:
            var _ = 0
        }
    }

}
