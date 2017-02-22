//
//  TopDownSegue.swift
//  Thread
//
//  Created by Michael Onjack on 2/21/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation

class TopDownSegue: UIStoryboardSegue {
    let duration: TimeInterval = 0.5
    let delay: TimeInterval = 0
    let animationOptions: UIViewAnimationOptions = [.curveEaseInOut]
    
    override func perform() {
        // get views
        let sourceView = source.view
        let destinationView = destination.view
        
        // get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        destinationView?.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
        
        // add destination view to view hierarchy
        UIApplication.shared.keyWindow?.insertSubview(destinationView!, aboveSubview: sourceView!)
        
        // animate
        UIView.animate(withDuration: duration, delay: delay, options: animationOptions, animations: {
            destinationView?.transform = CGAffineTransform.identity
        }) { (_) in
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
}
