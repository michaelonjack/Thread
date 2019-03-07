//
//  BiometricAuthenticationHelper.swift
//  Thread
//
//  Created by Michael Onjack on 3/6/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation
import LocalAuthentication

struct BiometricAuthenticationHelper {
    static let context = LAContext()
    static let loginReason = "Please authenticate to continue."
    
    
    /////////////////////////////////////////////////////
    //
    //  canEvaluatePolicy
    //
    //  Returns true if the current user's device supports biometric IDs
    //
    static func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  authenticateUser
    //
    //  Authenicate the current user using biometrics if available
    //
    static func authenticateUser(completion: @escaping (Error?) -> Void) {
        
        // If the device does support biometric ID, then prompt the user for their biometric info
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            
            if success {
                DispatchQueue.main.async {
                    // User authenticated successfully, take appropriate action
                    completion(nil)
                }
            } else {
                completion(evaluateError)
            }
        }
    }
    
    
    
    static func updateKeychainCredentials(email:String, password:String) {
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: email,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.set(true, forKey: "loginSaved")
    }
    
    
    
    static func getMessageForError(error: Error) -> String {
        switch error {
        case LAError.authenticationFailed:
            return "There was a problem verifying your identity."
        case LAError.userCancel:
            return "Authentication canceled."
        case LAError.userFallback:
            return "Authentication canceled."
        case LAError.biometryNotAvailable:
            return "Face ID/Touch ID is not available."
        case LAError.biometryNotEnrolled:
            return "Face ID/Touch ID is not set up."
        case LAError.biometryLockout:
            return "Face ID/Touch ID is locked."
        default:
            return "Face ID/Touch ID may not be configured"
        }
    }
}
