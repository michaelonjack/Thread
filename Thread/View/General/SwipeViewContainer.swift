//
//  SwipeViewContainer.swift
//  Thread
//
//  Created by Michael Onjack on 2/13/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SwipeViewContainer: UIView {
    
    var swipeViews: [SwipeView] = []
    var currentSwipeView: SwipeView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        
        swipeViews.reversed().forEach { (swipeView) in
            
            swipeView.delegate = self
            
            swipeView.removeFromSuperview()
            addSubview(swipeView)
        }
        
        currentSwipeView = swipeViews.first
        
        setupLayout()
    }
    
    func setupLayout() {
        
        for (index, swipeView) in swipeViews.enumerated() {
            swipeView.transform = CGAffineTransform.identity
            
            swipeView.constraints.forEach({ (constraint) in
                constraint.isActive = false
            })
            
            NSLayoutConstraint.activate([
                swipeView.topAnchor.constraint(equalTo: topAnchor),
                swipeView.bottomAnchor.constraint(equalTo: bottomAnchor),
                swipeView.leadingAnchor.constraint(equalTo: leadingAnchor),
                swipeView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            
            let floatIndex = CGFloat(index)
            swipeView.transform = swipeView.transform.translatedBy(x: 0, y: (frame.height * 0.1) * floatIndex)
            swipeView.transform = swipeView.transform.scaledBy(x: 1 - (0.1 * floatIndex), y: 1 - (0.1 * floatIndex))
        }
        
    }
    
    func reloadData() {
        setupView()
    }
}



extension SwipeViewContainer: SwipeViewDelegate {
    func swipeComplete(forView view: SwipeView) {
        
        if swipeViews.count < 2 { return }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.alpha = 0
        }, completion: { (_) in
            // Add the swiped away view to the back of the array
            self.swipeViews.removeFirst()
            self.swipeViews.append(view)
            
            // Send the view behind the other swipe views
            self.sendSubviewToBack(view)
            
            // Reset the view attributes that were modified by the swipe gesture
            view.transform = CGAffineTransform.identity
            view.center = view.originalCenter
            view.layer.position = view.originalPosition
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                for (index, swipeView) in self.swipeViews.enumerated() {
                    // Update the size and position of all of the swipe views in the container depending on their position in the pile
                    let floatIndex = CGFloat(index)
                    swipeView.transform = CGAffineTransform.identity
                    swipeView.transform = swipeView.transform.translatedBy(x: 0, y: 15 * floatIndex)
                    swipeView.transform = swipeView.transform.scaledBy(x: 1 - (0.1 * floatIndex), y: 1 - (0.1 * floatIndex))
                }
            }) { (_) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    view.alpha = 1
                })
            }
        })
    }
}
