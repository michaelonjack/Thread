//
//  HideLocationAnimationController.swift
//  Thread
//
//  Created by Michael Onjack on 5/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HideLocationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // The view controller being replaced
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? LocationViewController else { return }
        // The view controller being presented
        guard let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        let transitionImageView = UIImageView(image: fromController.locationImageView.image)
        transitionImageView.frame = fromController.view.frame
        transitionImageView.layer.masksToBounds = true
        transitionImageView.contentMode = .scaleAspectFill
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(transitionImageView, at: 0)
        containerView.insertSubview(toController.view, at: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            fromController.locationDetailsView.transform = .identity
            fromController.locationImageView.transform = .identity
        }) { [weak self] (_) in
            fromController.view.isHidden = true
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                transitionImageView.layer.cornerRadius = (self?.originFrame.height ?? 0) / 10.0
                transitionImageView.frame = self?.originFrame ?? CGRect.zero
            }, completion: { (_) in
                transitionContext.completeTransition( !transitionContext.transitionWasCancelled )
                transitionImageView.removeFromSuperview()
                fromController.view.isHidden = false
            })
        }
    }
}
