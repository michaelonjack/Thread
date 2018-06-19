//
//  InstructionsViewController.swift
//  
//
//  Created by Michael Onjack on 6/18/18.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var label1TopSpacing: NSLayoutConstraint!
    @IBOutlet weak var label2TopSpacing: NSLayoutConstraint!
    @IBOutlet weak var label3TopSpacing: NSLayoutConstraint!
    @IBOutlet weak var buttonTopSpacing: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIScreen.main.bounds.height < 667 {
            label1TopSpacing.constant = 70 * (UIScreen.main.bounds.height/667)
            label2TopSpacing.constant = 32 * (UIScreen.main.bounds.height/667)
            label3TopSpacing.constant = 32 * (UIScreen.main.bounds.height/667)
            buttonTopSpacing.constant = 80 * (UIScreen.main.bounds.height/667)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
