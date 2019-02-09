//
//  ViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/15/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//
//
//
//
// Login View Controller
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var loginViewsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonsView: LoginButtonsView!
    @IBOutlet weak var loginView: LoginView!
    @IBOutlet var loginViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var signUpView: SignUpView!
    @IBOutlet var signUpViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var aboutView: LoginAboutView!
    
    let usersRef = Database.database().reference(withPath: "users")
    
    var loginViewCenterYAnchor: NSLayoutConstraint!
    var signUpViewCenterYAnchor: NSLayoutConstraint!
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Checks if a user is already logged into the app. If so, skip the Me View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGradientBackground(startColor: UIColor.loginGradientStart, endColor: UIColor.loginGradientEnd)
        
        loginViewsTopConstraint.constant = view.frame.height * 0.5 * 0.35
        loginViewCenterYAnchor = loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        signUpViewCenterYAnchor = signUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        // Set button actions
        loginButtonsView.loginButton.addTarget(self, action: #selector(showLoginView), for: .touchUpInside)
        loginButtonsView.signupButton.addTarget(self, action: #selector(showSignUpView), for: .touchUpInside)
        loginView.cancelButton.addTarget(self, action: #selector(cancelLogIn), for: .touchUpInside)
        signUpView.cancelButton.addTarget(self, action: #selector(cancelSignUp), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signUpView.signupButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coordinator?.attemptAutoLogin()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Add gradients to buttons
        loginButtonsView.loginButton.addGradientBackground(startColor: UIColor.loginGradientStart, endColor: UIColor.loginGradientEnd, diagonal: false)
        
        loginButtonsView.signupButton.addGradientBackground(startColor: UIColor.signupGradientStart, endColor: UIColor.signupGradientEnd, diagonal: false)
        
        loginView.loginButton.addGradientBackground(startColor: UIColor.loginGradientStart, endColor: UIColor.loginGradientEnd, diagonal: false)
        
        signUpView.signupButton.addGradientBackground(startColor: UIColor.signupGradientStart, endColor: UIColor.signupGradientEnd, diagonal: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func showLoginView() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loginButtonsView.alpha = 0
            self.signUpView.alpha = 0
            self.aboutView.alpha = 0
            self.loginView.alpha = 1
            
            self.loginButtonsView.transform = self.loginButtonsView.transform.translatedBy(x: 0, y: 100)
            self.signUpView.transform = self.signUpView.transform.translatedBy(x: 0, y: 100)
            
            self.loginViewTopAnchor.isActive = false
            self.loginViewCenterYAnchor.isActive = true
            self.view.layoutSubviews()
        })
    }
    
    @objc func showSignUpView() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loginButtonsView.alpha = 0
            self.signUpView.alpha = 1
            self.aboutView.alpha = 0
            self.loginView.alpha = 0
            
            self.loginButtonsView.transform = self.loginButtonsView.transform.translatedBy(x: 0, y: 100)
            self.loginView.transform = self.loginView.transform.translatedBy(x: 0, y: 100)
            
            self.signUpViewTopAnchor.isActive = false
            self.signUpViewCenterYAnchor.isActive = true
            self.view.layoutSubviews()
        })
    }
    
    @objc func cancelLogIn() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loginButtonsView.alpha = 1
            self.aboutView.alpha = 1
            self.signUpView.alpha = 0.5
            self.loginView.alpha = 0.75
            
            self.loginButtonsView.transform = self.loginButtonsView.transform.translatedBy(x: 0, y: -100)
            self.signUpView.transform = self.signUpView.transform.translatedBy(x: 0, y: -100)
            
            self.loginViewCenterYAnchor.isActive = false
            self.loginViewTopAnchor.isActive = true
            self.view.layoutSubviews()
        })
    }
    
    @objc func cancelSignUp() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loginButtonsView.alpha = 1
            self.aboutView.alpha = 1
            self.signUpView.alpha = 0.5
            self.loginView.alpha = 0.75
            
            self.loginButtonsView.transform = self.loginButtonsView.transform.translatedBy(x: 0, y: -100)
            self.loginView.transform = self.loginView.transform.translatedBy(x: 0, y: -100)
            
            self.signUpViewCenterYAnchor.isActive = false
            self.signUpViewTopAnchor.isActive = true
            self.view.layoutSubviews()
        })
    }
    
    /////////////////////////////////////////////////////
    //
    //  login
    //
    //  Handles the action when the login button is pressed
    //  Uses the supplied email and password to give access to the current user to the app
    //
    @objc func login() {

        let email = loginView.emailField.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = loginView.passwordField.textField.text!

        Auth.auth().signIn(withEmail: email, password: password) {user,  error in
            if let user = Auth.auth().currentUser {

                // Check if user has already verified their email address
                if user.isEmailVerified {
                    self.coordinator?.login()
                }


                // Prompt user to verify their email in order to login
                else {
                    let verifyEmailAlert = UIAlertController(title: "Verify Email",
                                                             message: "Verify the email you provided to continue.\n\nResend verification?",
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
                    let closeAction = UIAlertAction(title: "Close", style:.default)

                    verifyEmailAlert.addAction(verifyAction)
                    verifyEmailAlert.addAction(closeAction)

                    self.present(verifyEmailAlert, animated: true, completion: nil)
                }
            }
            // If the login fails, display the error message to the user
            else {
                let errorAlert = UIAlertController(title: "Login Error",
                                                   message: error?.localizedDescription,
                                                   preferredStyle: .alert)

                let okayAction = UIAlertAction(title: "Close", style: .default)
                errorAlert.addAction(okayAction)
                self.present(errorAlert, animated: true, completion:nil)
            }
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  signUp
    //
    //  Validates the information entered by the user
    //  If validation passes, a new Firebase user is created
    //
    @objc func signUp() {
        let firstName = signUpView.firstNameField.textField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lastName = signUpView.lastNameField.textField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let email = signUpView.emailField.textField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = signUpView.passwordField.textField.text!
        let confirmPassword = signUpView.confirmPasswordField.textField.text!
        
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
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if error == nil {
                    
                    let user = authResult?.user
                    
                    let newUser = User(uid: (user?.uid)!, firstName: firstName, lastName: lastName, email: email)
                    let newUserRef = self.usersRef.child( newUser.uid )
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
    //  touchesBegan
    //
    //  Hides the keyboard when the user selects a non-textfield area
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

