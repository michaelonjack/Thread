//
//  UIViewController+Additions.swift
//  Thread
//
//  Created by Michael Onjack on 3/26/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showInfoNotification(message: String) {
        
        if notificationView.isShowing {
            return
        }
        
        notificationView.messageLabel.text = message
        
        let width: CGFloat = view.frame.width * 0.9
        let height: CGFloat = view.frame.height * 0.08
        let x = (view.frame.width - width) / 2
        let y = view.frame.maxY
        notificationView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        view.addSubview(notificationView)
        notificationView.show()
    }
    
}
