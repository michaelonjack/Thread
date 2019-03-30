//
//  NotificationQueue.swift
//  Thread
//
//  Created by Michael Onjack on 3/30/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation

class NotificationQueue: NSObject {
    static let shared: NotificationQueue = NotificationQueue()
    
    var notifications: [NotificationView] = []
    
    func addNotification(_ notification: NotificationView) {
        notifications.append(notification)
        
        if let index = notifications.firstIndex(of: notification), index == 0 {
            notification.show(addToQueue: false)
        }
        
    }
    
    func showNext() {
        if !notifications.isEmpty {
            notifications.removeFirst()
        }
        
        if let notification = notifications.first {
            notification.show(addToQueue: false)
        }
    }
}
