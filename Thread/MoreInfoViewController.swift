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
        
        let swipeToDismiss = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
        swipeToDismiss.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeToDismiss)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func swipeDown(_ gesture: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}
