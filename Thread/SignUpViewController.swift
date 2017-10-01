//
//  SignUpViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/12/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//
//
//
//
//  Sign Up View Controller
//
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    @IBOutlet weak var titleTopLayout: NSLayoutConstraint!
    @IBOutlet weak var firstNameTopLayout: NSLayoutConstraint!
    @IBOutlet weak var lastNameTopLayout: NSLayoutConstraint!
    
    let usersRef = Database.database().reference(withPath: "users")
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust the size of the top layout constraint depending on the screen height
        titleTopLayout.constant = 52 * (UIScreen.main.bounds.height/667)
        firstNameTopLayout.constant = 78 * (UIScreen.main.bounds.height/667)
        lastNameTopLayout.constant = 78 * (UIScreen.main.bounds.height/667)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  signUpDidTouch
    //
    //  Validates the information entered by the user
    //  If validation passes, a new Firebase user is created
    //
    @IBAction func signUpDidTouch(_ sender: Any) {
        let firstName = textFieldFirstName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lastName = textFieldLastName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let email = textFieldEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = textFieldPassword.text!
        let confirmPassword = textFieldConfirmPassword.text!
        
        if firstName == "" || lastName == "" || email == "" || password == "" || confirmPassword == "" {
            let errorAlert = UIAlertController(title: "Sign Up Error",
                                                  message: "All fields are required",
                                                  preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .default)
            errorAlert.addAction(closeAction)
            self.present(errorAlert, animated: true, completion:nil)
        } else if password != confirmPassword {
            let passwordAlert = UIAlertController(title: "Sign Up Error",
                                               message: "Passwords do not match",
                                               preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .default)
            passwordAlert.addAction(closeAction)
            self.present(passwordAlert, animated: true, completion:nil)
        } else {
            
            // Create a user using the user's provided email and password
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                
                if error == nil {
                    
                    let newUser = User(user: user!,
                                       firstName: firstName,
                                       lastName: lastName,
                                       status: "")
                    let newUserRef = self.usersRef.child((user?.uid)!)
                    
                    
                    newUserRef.setValue(newUser.toAnyObject())
                    
                    
                    // If no errors occurred when creating the user, send them a verification email
                    user?.sendEmailVerification(completion: nil)
                    
                    // Create a new pop-up action notifying the user that their registration was successful and a verification email has been sent
                    let verifyEmailAlert = UIAlertController(title: "Verify Email",
                                                             message: "Verification sent!\n\nLogin with your new email/password after verifying.",
                                                             preferredStyle: .alert)
                    
                    // Okay action to close out of the pop-up alert
                    let closeAction = UIAlertAction(title: "Close", style:.default) { action in
                            self.dismiss(animated: true, completion: nil)
                    }
                    
                    verifyEmailAlert.addAction(closeAction)
                    
                    self.present(verifyEmailAlert, animated: true, completion: nil)
                } else {
                    let errorAlert = UIAlertController(title: "Sign Up Error",
                                                       message: error?.localizedDescription,
                                                       preferredStyle: .alert)
                    
                    let closeAction = UIAlertAction(title: "Close", style: .default)
                    errorAlert.addAction(closeAction)
                    self.present(errorAlert, animated: true, completion:nil)
                }
            }
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  cancelDidTouch
    //
    //  Dismisses the Sign Up view to return to the Login view
    //
    @IBAction func cancelDidTouch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  touchesBegan
    //
    //  Hides the keyboard when the user selects a non-textfield area
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
