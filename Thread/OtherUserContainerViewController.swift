//
//  OtherUserContainerViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/26/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class OtherUserContainerViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!

    var otherUser: User!
    
    var iconViewController: OtherUserViewController?
    var imageViewController: OtherUserAltViewController?
    var activeViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        iconViewController = sb.instantiateViewController(withIdentifier: "OtherUserIconVC") as? OtherUserViewController
        iconViewController?.otherUser = self.otherUser
        iconViewController?.containerViewController = self
        
        imageViewController = sb.instantiateViewController(withIdentifier: "OtherUserImageVC") as? OtherUserAltViewController
        imageViewController?.otherUser = self.otherUser
        imageViewController?.containerViewController = self
        
        self.addChildViewController(iconViewController!)
        iconViewController?.view.frame = mainView.bounds
        
        mainView.addSubview((iconViewController?.view)!)
        
        iconViewController?.didMove(toParentViewController: self)
        
        activeViewController = iconViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  cycle
    //
    //  Switches the active view from oldVC to newVC
    //
    func cycle(from oldVC: UIViewController,
               to newVC: UIViewController,
               direction: UIViewAnimationOptions) -> Void {
        
        // prepare for the transition
        oldVC.willMove(toParentViewController: nil)
        
        self.addChildViewController(newVC)
        
        newVC.view.frame = mainView.bounds
        
        UIView.transition(
            with: mainView,
            duration: 0.8,
            options: direction,
            animations: {
                oldVC.view.removeFromSuperview()
                self.mainView.addSubview(newVC.view)
        }, completion: {
            finished in
            self.activeViewController = newVC
        })
        
    }

}
