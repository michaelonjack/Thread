//
//  AppDelegate.swift
//  Thread
//
//  Created by Michael Onjack on 1/15/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import SwipeNavigationController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Move firebase configuration to init to avoid race conditions with the database instantiation on the login page
    override init() {
        super.init()
        
        FirebaseApp.configure()
        // Allow Firebase database to work offline
        Database.database().isPersistenceEnabled = true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tangerine = UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
        
        // Make navigation bar transparent
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: tangerine, NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 20)!], for: .normal)
        
        // Make navigation bar text tangerine
        UINavigationBar.appearance().tintColor = tangerine
        
        // Enable the IQKeyboard
        IQKeyboardManager.shared.enable = true
        
        // Determine which view controller should be initially shown
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController = UIViewController()
        
        // User is logged in, go right to profile
        if (Auth.auth().currentUser != nil) {
            let outfitViewController = mainStoryboard.instantiateViewController(withIdentifier: "MeOutfitViewController") as! MeOutfitViewController
            let closetViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClosetNavigationController") as! UINavigationController
            let aroundMeController = mainStoryboard.instantiateViewController(withIdentifier: "UserTableViewController") as! UserTableViewController
            
            let swipeNavigationController = SwipeNavigationController(centerViewController: outfitViewController)
            swipeNavigationController.leftViewController = aroundMeController
            swipeNavigationController.rightViewController = closetViewController
            swipeNavigationController.shouldShowTopViewController = false
            swipeNavigationController.shouldShowBottomViewController = false
            
            initialViewController = swipeNavigationController
        }
        
        // User is not logged in, go to login screen
        else {
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

