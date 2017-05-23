//
//  PasswordViewController.swift
//  Thread
//
//  Created by Michael Onjack on 4/15/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var textFieldCurrentPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    let currentUser = Auth.auth().currentUser
    let threadKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the font of the navigation bar's header
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Avenir-Book", size: 20)!,
            NSForegroundColorAttributeName: UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
        ]

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // updatePasswordDidTouch
    //
    // Updates the current user's password
    //
    @IBAction func updatePasswordDidTouch(_ sender: Any) {
        let currentPassword = textFieldCurrentPassword.text
        let newPassword = textFieldNewPassword.text
        let confirmNewPassword = textFieldConfirmPassword.text
        
        // Check to make sure the user entered a new password
        if newPassword == nil || newPassword == "" {
            let noPassAlert = UIAlertController(title: "No Password Entered", message: "Please enter a new password.", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .default)
            noPassAlert.addAction(closeAction)
            self.present(noPassAlert, animated: true, completion:nil)
        }
        
        // Check to make sure the new password matches the confirmation
        else if newPassword != confirmNewPassword {
            let mismatchAlert = UIAlertController(title: "Passwords Do Not Match", message: "The passwords you've entered do not match. Please reenter the new password and try again.", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .default)
            mismatchAlert.addAction(closeAction)
            self.present(mismatchAlert, animated: true, completion:nil)
        }
        
        else {
            
            currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get the current user's email address
                let currentUserValue = snapshot.value as? NSDictionary
                let userEmail = currentUserValue?["email"] as? String ?? ""
                
                // Use the signIn function to validate the current password
                Auth.auth().signIn(withEmail: userEmail, password: currentPassword!, completion: { (user, error) in
                    
                    // If no error then the current password is correct so update to the new password
                    if error == nil {
                        self.currentUser?.updatePassword(to: newPassword!, completion: { (error) in
                            
                            if error == nil {
                                // Update password in keychain
                                self.threadKeychainWrapper.mySetObject(newPassword, forKey:kSecValueData)
                                self.threadKeychainWrapper.writeToKeychain()
                                UserDefaults.standard.synchronize()
                            }
                            
                            // Error updating the password
                            else {
                                let updateErrorAlert = UIAlertController(title: "Error Updating Password", message: error?.localizedDescription, preferredStyle: .alert)
                                
                                let closeAction = UIAlertAction(title: "Close", style: .default)
                                updateErrorAlert.addAction(closeAction)
                                self.present(updateErrorAlert, animated: true, completion:nil)
                            }
                        })
                    }
                    
                    // If error, then the current password is incorrect
                    else {
                        let wrongPassAlert = UIAlertController(title: "Current Password Incorrect", message: "The current password is not correct. Reenter the password and try again.", preferredStyle: .alert)
                        
                        let closeAction = UIAlertAction(title: "Close", style: .default)
                        wrongPassAlert.addAction(closeAction)
                        self.present(wrongPassAlert, animated: true, completion:nil)
                    }
                })
                
            })
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    // forgotPasswordDidTouch
    //
    // Sends the user a password reset email
    //
    @IBAction func forgotPasswordDidTouch(_ sender: Any) {
        
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get the current user's email address
            let currentUser = snapshot.value as? NSDictionary
            let userEmail = currentUser?["email"] as? String ?? ""
            
            // If the user has an email saved, send a reset email
            if userEmail != "" {
                Auth.auth().sendPasswordReset(withEmail: userEmail, completion: { (error) in
                    
                    // If no error, send a reset password email
                    if error == nil {
                        let resetPassAlert = UIAlertController(title: "Reset Email Sent", message: "An email to reset your password has been sent to " + userEmail, preferredStyle: .alert)
                        
                        let closeAction = UIAlertAction(title: "Close", style: .default)
                        resetPassAlert.addAction(closeAction)
                        self.present(resetPassAlert, animated: true, completion:nil)
                    }
                    
                    // If an error is encountered, show error description in alert
                    else {
                        let errorAlert = UIAlertController(title: "Error Sending Reset Email", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let closeAction = UIAlertAction(title: "Close", style: .default)
                        errorAlert.addAction(closeAction)
                        self.present(errorAlert, animated: true, completion:nil)
                    }
                })
            }
            
            // Show alert if the user does not have an email address saved
            else {
                let errorAlert = UIAlertController(title: "No Email Address", message: "A password reset email could not be sent because you do not have a saved email address.", preferredStyle: .alert)
                
                let closeAction = UIAlertAction(title: "Close", style: .default)
                errorAlert.addAction(closeAction)
                self.present(errorAlert, animated: true, completion:nil)
            }
        })
        
    }
    
    

}
