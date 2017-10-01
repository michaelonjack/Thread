//
//  DatePickerViewController.swift
//  Thread
//
//  Created by Michael Onjack on 3/31/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonUpdate: UIButton!
    @IBOutlet weak var labelBirthday: UILabel!
    
    @IBOutlet weak var labelContainerTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var viewTopSpacing: NSLayoutConstraint!
    
    let currentUserRef = Database.database().reference(withPath: "users/" + (Auth.auth().currentUser?.uid)!)
    
    var birthdayStr: String = ""
    var birthdayDate: Date? = nil
    var presentingVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust constraints for screen size
        labelContainerTopSpacing.constant = 133 * (UIScreen.main.bounds.height/667)
        viewTopSpacing.constant = 22 * (UIScreen.main.bounds.height/667)
        

        // Set the font of the navigation bar's header
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
        ]
        
        labelBirthday.text = birthdayStr
        if let bDate = birthdayDate {
            datePicker.date = bDate
        }
        
        buttonUpdate.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let selectedDate = dateFormatter.string(from: self.datePicker.date)
        
        self.buttonUpdate.isHidden = false
        self.labelBirthday.text = selectedDate
    }
    
    
    
    @IBAction func updateDidTouch(_ sender: Any) {
        currentUserRef.updateChildValues(["birthday": labelBirthday.text ?? ""])
        self.buttonUpdate.isHidden = true
        
        if let presentingVC = self.presentingVC as? SettingsViewController {
            presentingVC.loadProfileData()
        }
    }
    

}
