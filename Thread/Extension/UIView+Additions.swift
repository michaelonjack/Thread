//
//  UIView+Additions.swift
//  Thread
//
//  Created by Michael Onjack on 2/7/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

extension UIView {
    func addGradientBackground(startColor: UIColor, endColor: UIColor, diagonal: Bool = true) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        if diagonal {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        gradientLayer.locations = [0, 1]
        
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
