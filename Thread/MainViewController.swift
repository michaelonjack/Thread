//
//  MainViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/16/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    let logoutToLogin = "LogoutToLogin"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func meDidTouch(_ sender: AnyObject) {
        
    }

    @IBAction func aroundMeDidTouch(_ sender: AnyObject) {
        
    }
    
    @IBAction func logOutDidTouch(_ sender: AnyObject) {
        do {
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: self.logoutToLogin, sender: nil)
        } catch {
            print("Error while signing out")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
