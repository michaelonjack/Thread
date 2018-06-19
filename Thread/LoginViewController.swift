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
import SwipeNavigationController

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var buttonTouchID: UIButton!
    @IBOutlet weak var topLayoutConstrait: NSLayoutConstraint!
    
    let usersRef = Database.database().reference(withPath: "users")
    let threadKeychainWrapper = KeychainWrapper()
    
    var authContext = LAContext()
    
    
    
    /////////////////////////////////////////////////////
    //
    //  viewDidLoad
    //
    //  Checks if a user is already logged into the app. If so, skip the Me View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust the size of the top layout constraint depending on the screen height
        if (UIScreen.main.bounds.height < 667) {
            topLayoutConstrait.constant = 247 * (UIScreen.main.bounds.height/667)
        }
        
        buttonTouchID.isHidden = true
        
        // If the user's device supports touch ID and their login is stored in the keychain, show the touch ID button
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && UserDefaults.standard.bool(forKey: "hasLoginKey"){
            buttonTouchID.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  loginDidTouch
    //
    //  Handles the action when the login button is pressed
    //  Uses the supplied email and password to give access to the current user to the app
    //
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        
        let email = textFieldLoginEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = textFieldLoginPassword.text!
        
        Auth.auth().signIn(withEmail: email, password: password) {user,  error in
            if let user = Auth.auth().currentUser {
                
                // Check if user has already verified their email address
                if user.isEmailVerified {
                    
                    // Check if the user has already supplied their credentials to keychain
                    let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
                    if hasLoginKey == false {
                        // If not, store their email and password to the keychain
                        UserDefaults.standard.setValue(self.textFieldLoginEmail.text, forKey: "userEmail")
                        
                        self.threadKeychainWrapper.mySetObject(self.textFieldLoginPassword.text, forKey:kSecValueData)
                        self.threadKeychainWrapper.writeToKeychain()
                        UserDefaults.standard.set(true, forKey: "hasLoginKey")
                        UserDefaults.standard.synchronize()
                    }
                    
                    // Create the swipe controller
                    let swipeNavigationController = self.createSwipeController()
                    
                    DispatchQueue.main.async {
                        self.present(swipeNavigationController, animated: true, completion: nil)
                    }
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
    //  touchIDDidTouch
    //
    //  Authenitcates the user via touch ID
    //  Uses their email/password stored in keychain
    //
    @IBAction func touchIDDidTouch(_ sender: Any) {
        // Check to be sure the user's device supports touch ID
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with Touch ID", reply: { (success, error) in
                
                DispatchQueue.main.async {
                    if success {
                        if UserDefaults.standard.bool(forKey: "hasLoginKey") {
                            let userEmail = UserDefaults.standard.value(forKey: "userEmail") as! String
                            let userPassword = self.threadKeychainWrapper.myObject(forKey: "v_Data") as! String
    
                            Auth.auth().signIn(withEmail: userEmail, password: userPassword) { user, error in
                                if let user = Auth.auth().currentUser {
                                    // Check if user has already verified their email address
                                    if user.isEmailVerified {
                                        // Create the swipe controller
                                        let swipeNavigationController = self.createSwipeController()
                                        
                                        DispatchQueue.main.async {
                                            self.present(swipeNavigationController, animated: true, completion: nil)
                                        }
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
                        } else {
                            print("login not saved in keychain")
                        }
                    }
                }
            })
        }
    }
    
    
    
    func createSwipeController() -> UIViewController {
        // Create the swipe controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let outfitViewController = mainStoryboard.instantiateViewController(withIdentifier: "MeOutfitViewController") as! MeOutfitViewController
        let closetViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClosetNavigationController") as! UINavigationController
        let aroundMeController = mainStoryboard.instantiateViewController(withIdentifier: "UserTableViewController") as! UserTableViewController
        let settingsController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsNavigationController") as! UINavigationController
        
        let swipeNavigationController = SwipeNavigationController(centerViewController: outfitViewController)
        swipeNavigationController.leftViewController = aroundMeController
        swipeNavigationController.rightViewController = closetViewController
        swipeNavigationController.topViewController = settingsController
        swipeNavigationController.shouldShowTopViewController = true
        swipeNavigationController.shouldShowBottomViewController = false
        
        return swipeNavigationController
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

