//
//  ConstraintHelper.swift
//  Thread
//
//  Created by Michael Onjack on 9/11/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}




/////////////////////////////////////////////////////
//
//  scaleConstraintMultiplierForWidth
//
//
//
func scaleConstraintMultiplierForWidth(constraint: NSLayoutConstraint, originalWidth: CGFloat, parentView:UIView) {
    let newImageConstraint = constraint.constraintWithMultiplier( (originalWidth/667) * (UIScreen.main.bounds.height/UIScreen.main.bounds.width))
    parentView.removeConstraint(constraint)
    parentView.addConstraint(newImageConstraint)
    parentView.layoutIfNeeded()
}




/////////////////////////////////////////////////////
//
//  scaleConstraintMultiplierForHeighth
//
//
//
func scaleConstraintMultiplierForHeighth(constraint: NSLayoutConstraint, originalHeight: CGFloat, parentView:UIView) {
    let newImageConstraint = constraint.constraintWithMultiplier( (originalHeight/375) * (UIScreen.main.bounds.width/UIScreen.main.bounds.height))
    parentView.removeConstraint(constraint)
    parentView.addConstraint(newImageConstraint)
    parentView.layoutIfNeeded()
}
    
