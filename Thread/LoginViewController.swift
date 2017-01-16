//
//  ViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/15/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let loginToMain = "LoginToMain"

    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    
                // Prompt user to verify their email
                else {
                    let verifyEmailAlert = UIAlertController(title: "verify email",
                                                             message: "Verify the email you provided to continue. Resend verification?",
                                                             preferredStyle: .alert)
                    let verifyAction = UIAlertAction(title: "Resend", style: .default) { action in
                        user.sendEmailVerification(completion: {
                            (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        })
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style:.default)
                    
                    verifyEmailAlert.addAction(verifyAction)
                    verifyEmailAlert.addAction(cancelAction)
                    
                    self.present(verifyEmailAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Sign up the user with the requested email/password
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "sign up for thread",
                                      message: "",
                                      preferredStyle: .alert)
        
        let registerAction = UIAlertAction(title: "Register", style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                
                if error == nil {
                    user?.sendEmailVerification(completion: nil)
                    
                    let verifyEmailAlert = UIAlertController(title: "verify email",
                                                             message: "Verification sent! Login with your new email/password after verifying.",
                                                             preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "Okay", style:.default)
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
        
        let cancelAction = UIAlertAction(title:"Cancel", style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "enter your email"
        }
        
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

