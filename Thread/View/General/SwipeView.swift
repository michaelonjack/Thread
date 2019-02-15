//
//  SwipeView.swift
//  Thread
//
//  Created by Michael Onjack on 2/13/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

protocol SwipeViewDelegate: class {
    func swipeComplete(forView view: SwipeView)
}

class SwipeView: UIView {
    
    weak var delegate: SwipeViewDelegate?
    var originalCenter: CGPoint = .zero
    var originalPosition: CGPoint = .zero
    var dragPercent: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        originalCenter = center
        originalPosition = layer.position
    }
    
    func setupView() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swiped)))
    }
    
    @objc func swiped(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            let initialTouchPoint = gesture.location(in: self)
            
            let newAnchorPoint = CGPoint(x: (initialTouchPoint.x / bounds.width), y: (initialTouchPoint.y / bounds.height))
            
            // Update the layer's position for the new anchor point
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
            
        case .changed:
            let gestureTranslation = gesture.translation(in: self)
            
            let rotationStrength = min(gestureTranslation.x / frame.width, 1.0)
            let maxRotationAngle = CGFloat.pi / 4.0
            let rotationAngle = rotationStrength * maxRotationAngle
            
            var transform = CGAffineTransform.identity
            transform = transform.rotated(by: rotationAngle)
            transform = transform.translatedBy(x: gestureTranslation.x, y: gestureTranslation.y / 2)
            
            self.transform = transform
            
            if let swipeContainerView = superview {
                dragPercent = abs( gestureTranslation.x / (swipeContainerView.frame.width / 2) )
            }
            
        case .ended:
            if dragPercent > 0.95 {
                self.delegate?.swipeComplete(forView: self)
            }
                
            else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity
                    self.center = self.originalCenter
                    self.layer.position =  self.originalPosition
                    self.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
                })
            }
        default:
            break
        }
    }
}
