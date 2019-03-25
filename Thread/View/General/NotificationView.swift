//
//  NotificationView.swift
//  Thread
//
//  Created by Michael Onjack on 3/25/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

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
    
    init(message: String) {
        super.init(frame: .zero)
        
        messageLabel.text = message
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
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 8, height: 8)
        layer.shadowOpacity = 0.4
        backgroundColor = .white
        //alpha = 0
        
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
            leadingBorder.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05),
            
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
    
    func show() {
        guard let superview = superview else { return }
        
        let translateY = (frame.maxY - superview.frame.maxY) + frame.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = self.transform.translatedBy(x: 0, y: -translateY)
        }) { (_) in
            print(superview.frame)
            print(self.frame)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.dismiss()
            })
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform.identity
        })
    }
}
