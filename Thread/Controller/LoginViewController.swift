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
import LocalAuthentication

class LoginViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var loginButtonsView: LoginButtonsView!
    @IBOutlet weak var loginView: LoginView!
    @IBOutlet var loginViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var signUpView: SignUpView!
    @IBOutlet var signUpViewTopAnchor: NSLayoutConstraint!
    //    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var touchIDButton: UIButton!
    
    let usersRef = Database.database().reference(withPath: "users")
    
    var authContext = LAContext()
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
        
        loginViewCenterYAnchor = loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        signUpViewCenterYAnchor = signUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        loginButtonsView.loginButton.addTarget(self, action: #selector(showLoginView), for: .touchUpInside)
        loginButtonsView.signupButton.addTarget(self, action: #selector(showSignUpView), for: .touchUpInside)
        loginView.cancelButton.addTarget(self, action: #selector(cancelLogIn), for: .touchUpInside)
        signUpView.cancelButton.addTarget(self, action: #selector(cancelSignUp), for: .touchUpInside)
        
//        touchIDButton.isHidden = true
//
//        // If the user's device supports touch ID and their login is stored in the keychain, show the touch ID button
//        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && UserDefaults.standard.bool(forKey: "hasLoginKey"){
//            touchIDButton.isHidden = false
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coordinator?.attemptAutoLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func showLoginView() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loginButtonsView.alpha = 0
            self.signUpView.alpha = 0
            self.loginView.alpha = 1
            
            self.loginButtonsView.transform = self.loginButtonsView.transform.translatedBy(x: 0, y: 100)
            self.signUpView.transform = self.signUpView.transform.translatedBy(x: 0, y: 100)
            
            self.loginViewTopAnchor.isActive = false
            self.loginViewCenterYAnchor.isActive = true
            self.view.layoutSubviews()
        })
    }
    
    @objc func showSignUpView() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loginButtonsView.alpha = 0
            self.signUpView.alpha = 1
            self.loginView.alpha = 0
            
            self.loginButtonsView.transform = self.loginButtonsView.transform.translatedBy(x: 0, y: 100)
            self.loginView.transform = self.loginView.transform.translatedBy(x: 0, y: 100)
            
            self.signUpViewTopAnchor.isActive = false
            self.signUpViewCenterYAnchor.isActive = true
            self.view.layoutSubviews()
        })
    }
    
    @objc func cancelLogIn() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loginButtonsView.alpha = 1
            self.signUpView.alpha = 1
            self.loginView.alpha = 1
            
            self.loginButtonsView.transform = self.loginButtonsView.transform.translatedBy(x: 0, y: -100)
            self.signUpView.transform = self.signUpView.transform.translatedBy(x: 0, y: -100)
            
            self.loginViewCenterYAnchor.isActive = false
            self.loginViewTopAnchor.isActive = true
            self.view.layoutSubviews()
        })
    }
    
    @objc func cancelSignUp() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loginButtonsView.alpha = 1
            self.signUpView.alpha = 1
            self.loginView.alpha = 1
            
            self.loginButtonsView.transform = self.loginButtonsView.transform.translatedBy(x: 0, y: -100)
            self.loginView.transform = self.loginView.transform.translatedBy(x: 0, y: -100)
            
            self.signUpViewCenterYAnchor.isActive = false
            self.signUpViewTopAnchor.isActive = true
            self.view.layoutSubviews()
        })
    }
    
    /////////////////////////////////////////////////////
    //
    //  loginDidTouch
    //
    //  Handles the action when the login button is pressed
    //  Uses the supplied email and password to give access to the current user to the app
    //
//    @IBAction func login(_ sender: AnyObject) {
//
//        let email = emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        let password = passwordTextField.text!
//
//        Auth.auth().signIn(withEmail: email, password: password) {user,  error in
//            if let user = Auth.auth().currentUser {
//
//                // Check if user has already verified their email address
//                if user.isEmailVerified {
//                    self.coordinator?.login()
//                }
//
//
//                // Prompt user to verify their email in order to login
//                else {
//                    let verifyEmailAlert = UIAlertController(title: "Verify Email",
//                                                             message: "Verify the email you provided to continue.\n\nResend verification?",
//                                                             preferredStyle: .alert)
//
//                    // Verify action sends the user another verification email
//                    let verifyAction = UIAlertAction(title: "Resend", style: .default) { action in
//                        user.sendEmailVerification(completion: {
//                            (error) in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            }
//                        })
//                    }
//
//                    // Cancel action closes the pop-up alert
//                    let closeAction = UIAlertAction(title: "Close", style:.default)
//
//                    verifyEmailAlert.addAction(verifyAction)
//                    verifyEmailAlert.addAction(closeAction)
//
//                    self.present(verifyEmailAlert, animated: true, completion: nil)
//                }
//            }
//            // If the login fails, display the error message to the user
//            else {
//                let errorAlert = UIAlertController(title: "Login Error",
//                                                   message: error?.localizedDescription,
//                                                   preferredStyle: .alert)
//
//                let okayAction = UIAlertAction(title: "Close", style: .default)
//                errorAlert.addAction(okayAction)
//                self.present(errorAlert, animated: true, completion:nil)
//            }
//        }
//    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  touchIDDidTouch
    //
    //  Authenitcates the user via touch ID
    //  Uses their email/password stored in keychain
    //
//    @IBAction func touchID(_ sender: Any) {
//        // Check to be sure the user's device supports touch ID
//        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
//            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with Touch ID", reply: { (success, error) in
//
//                DispatchQueue.main.async {
//                    if success {
//                        if UserDefaults.standard.bool(forKey: "hasLoginKey") {
//                            let userEmail = UserDefaults.standard.value(forKey: "userEmail") as! String
//                            let userPassword = ""
//
//                            Auth.auth().signIn(withEmail: userEmail, password: userPassword) { user, error in
//                                if let user = Auth.auth().currentUser {
//                                    // Check if user has already verified their email address
//                                    if user.isEmailVerified {
//
//                                        DispatchQueue.main.async {
//                                            self.present(UIViewController(), animated: true, completion: nil)
//                                        }
//                                    }
//                                }
//                                // If the login fails, display the error message to the user
//                                else {
//                                    let errorAlert = UIAlertController(title: "Login Error",
//                                                                       message: error?.localizedDescription,
//                                                                       preferredStyle: .alert)
//
//                                    let okayAction = UIAlertAction(title: "Close", style: .default)
//                                    errorAlert.addAction(okayAction)
//                                    self.present(errorAlert, animated: true, completion:nil)
//                                }
//                            }
//                        } else {
//                            print("login not saved in keychain")
//                        }
//                    }
//                }
//            })
//        }
//    }
    
    
    
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

