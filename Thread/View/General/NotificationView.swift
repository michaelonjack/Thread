//
//  NotificationView.swift
//  Thread
//
//  Created by Michael Onjack on 3/25/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

enum NotificationType {
    case error
    case info
}

class NotificationView: UIView {
    
    var leadingBorder: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        
        return v
    }()
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "AppIcon")
        
        return iv
    }()
    
    var messageLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 2
        l.textColor = .black
        l.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        
        return l
    }()
    
    var isShowing: Bool = false
    var type: NotificationType = .info
    let notificationQueue: NotificationQueue = NotificationQueue.shared
    
    init(type: NotificationType, message: String) {
        super.init(frame: .zero)
        
        self.type = type
        messageLabel.text = message
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        switch type {
        case .error:
            leadingBorder.backgroundColor = .red
            
        case .info:
            leadingBorder.backgroundColor = .black
        }
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 8, height: 8)
        layer.shadowOpacity = 0.4
        backgroundColor = .white
        alpha = 0
        
        addSubview(leadingBorder)
        addSubview(imageView)
        addSubview(messageLabel)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            leadingBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            leadingBorder.topAnchor.constraint(equalTo: topAnchor),
            leadingBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            leadingBorder.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.03),
            
            imageView.leadingAnchor.constraint(equalTo: leadingBorder.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func show(addToQueue:Bool = true) {
        
        if addToQueue {
            notificationQueue.addNotification(self)
            return
        }
        
        guard let appWindow = UIApplication.shared.keyWindow else { return }
        
        let width: CGFloat = appWindow.frame.width * 0.9
        let height: CGFloat = appWindow.frame.height * 0.08
        let x = (appWindow.frame.width - width) / 2
        let y = appWindow.frame.maxY
        frame = CGRect(x: x, y: y, width: width, height: height)
        
        appWindow.addSubview(self)
        
        isShowing = true
        
        let translateY = (frame.maxY - appWindow.frame.maxY) + (frame.height * 2)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = self.transform.translatedBy(x: 0, y: -translateY)
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.dismiss()
            })
        }
    }
    
    func dismiss() {
        
        guard isShowing else { return }
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform.identity
        }) { (_) in
            self.isShowing = false
            self.removeFromSuperview()
            self.notificationQueue.showNext()
        }
    }
}
