//
//  MoreInfoViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/16/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {

    @IBOutlet weak var textViewName: UITextView!
    @IBOutlet weak var textViewBrand: UITextView!
    @IBOutlet weak var textViewLink: UITextView!
    
    var clothingItem: ClothingItem!
    var canEdit: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewName.text = clothingItem.name
        textViewBrand.text = clothingItem.brand
        textViewLink.text = clothingItem.itemUrl
        
        textViewName.isEditable = canEdit
        textViewBrand.isEditable = canEdit
        textViewLink.isEditable = canEdit
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Determines how blurred the view is
        blurEffectView.alpha = 0.9
        // Places the blur view behind the other UI components
        self.view.insertSubview(blurEffectView, at: 0)
        
        let swipeToDismiss = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
        swipeToDismiss.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeToDismiss)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func swipeDown(_ gesture: UIGestureRecognizer) {
        
        // Pass back the new information to the presenting view controller
        if self.canEdit == true {
            if let presentingVC = self.presentingViewController as! ClothingItemViewController? {
                presentingVC.clothingItem.name = self.textViewName.text
                presentingVC.clothingItem.brand = self.textViewBrand.text
                presentingVC.clothingItem.itemUrl = self.textViewLink.text
            }
        }
        
        self.dismiss(animated: true, completion: nil)
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
