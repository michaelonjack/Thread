//
//  ViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/15/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginToMain = "LoginToMain"
    let usersRef = FIRDatabase.database().reference(withPath: "users")

    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If a user is already logged in, skip login view and continue to the main view
        FIRAuth.auth()?.addStateDidChangeListener() { auth, user in
            if user != nil && (user?.isEmailVerified)! {
                self.performSegue(withIdentifier: self.loginToMain, sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // Login user with given password and email
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!) {user,  error in
            if let user = FIRAuth.auth()?.currentUser {
                
                // Check if user has already verified their email address
                if user.isEmailVerified {
                    self.performSegue(withIdentifier: self.loginToMain, sender: nil)
                }
                    
                // Prompt user to verify their email in order to login
                else {
                    let verifyEmailAlert = UIAlertController(title: "verify email",
                                                             message: "Verify the email you provided to continue. Resend verification?",
                                                             preferredStyle: .alert)
                    
                    // Verify action sends the user another verification email
                    let verifyAction = UIAlertAction(title: "Resend", style: .default) { action in
                        user.sendEmailVerification(completion: {
                            (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        })
                    }
                    
                    // Cancel action closes the pop-up alert
                    let cancelAction = UIAlertAction(title: "Cancel", style:.default)
                    
                    verifyEmailAlert.addAction(verifyAction)
                    verifyEmailAlert.addAction(cancelAction)
                    
                    self.present(verifyEmailAlert, animated: true, completion: nil)
                }
            }
            // If the login fails, display the error message to the user
            else {
                let errorAlert = UIAlertController(title: "login error",
                                                   message: error?.localizedDescription,
                                                   preferredStyle: .alert)
                
                let okayAction = UIAlertAction(title: "okay", style: .default)
                errorAlert.addAction(okayAction)
                self.present(errorAlert, animated: true, completion:nil)
            }
        }
    }
    
    
    
    
    
    // Sign up the user with the requested email/password
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        
        // Create pop-up alert requesting the user's registration information
        let alert = UIAlertController(title: "sign up for thread",
                                      message: "",
                                      preferredStyle: .alert)
        
        // Register action handles when the user chooses to register
        let registerAction = UIAlertAction(title: "Register", style: .default) { action in
            let firstNameField = alert.textFields![0]
            let lastNameField = alert.textFields![1]
            let emailField = alert.textFields![2]
            let passwordField = alert.textFields![3]
            
            // Create a user using the user's provided email and password
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                
                if error == nil {
                    
                    let newUser = User(user: user!,
                                       firstName: firstNameField.text!,
                                       lastName: lastNameField.text!)
                    let newUserRef = self.usersRef.child((user?.uid)!)
                    
                    
                    newUserRef.setValue(newUser.toAnyObject())
                    
                    
                    // If no errors occurred when creating the user, send them a verification email
                    user?.sendEmailVerification(completion: nil)
                    
                    // Create a new pop-up action notifying the user that their registration was successful and a verification email has been sent
                    let verifyEmailAlert = UIAlertController(title: "verify email",
                                                             message: "Verification sent! Login with your new email/password after verifying.",
                                                             preferredStyle: .alert)
                    
                    // Okay action to close out of the pop-up alert
                    let okayAction = UIAlertAction(title: "Okay", style:.default)
                    
                    // Resend action which will resend the verification email
                    let resendAction = UIAlertAction(title: "Resend", style: .default) { action in
                        user?.sendEmailVerification(completion: {
                            (error) in
                            if let error = error { print(error.localizedDescription) }
                        })
                    }
                    
                    verifyEmailAlert.addAction(okayAction)
                    verifyEmailAlert.addAction(resendAction)
                    
                    self.present(verifyEmailAlert, animated: true, completion: nil)
                } else { print(error?.localizedDescription) }
            }
        }
        
        // Cancel action handles when user wishes to cancel registration
        let cancelAction = UIAlertAction(title:"Cancel", style: .default)
        
        // Text field on the pop-up alert for the user's first name
        alert.addTextField { textFirstName in
            textFirstName.placeholder = "first name"
        }
        
        // Text field on the pop-up alert for the user's last name
        alert.addTextField { textLastName in
                textLastName.placeholder = "last name"
        }
        
        // Text field on the pop-up alert for the user's email
        alert.addTextField { textEmail in
            textEmail.placeholder = "enter your email"
        }
        
        // Text field on the pop-up alert for the user's password
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "enter your password"
        }
        
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadGif( fileName: String ) {
        
    }


}

