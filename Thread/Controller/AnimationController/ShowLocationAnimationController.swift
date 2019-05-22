//
//  ShowLocationAnimationController.swift
//  Thread
//
//  Created by Michael Onjack on 5/17/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ShowLocationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var locationImage: UIImage?
    var originFrame: CGRect
    
    init(originFrame: CGRect, locationImage: UIImage?) {
        self.originFrame = originFrame
        self.locationImage = locationImage
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // The view controller being replaced
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        // The view controller being presented
        guard let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? LocationViewController else { return }
        
        let transitionImageView = UIImageView(image: locationImage)
        transitionImageView.frame = originFrame
        transitionImageView.layer.masksToBounds = true
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.layer.cornerRadius = originFrame.height / 10.0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toController.view)
        containerView.addSubview(transitionImageView)
        toController.view.isHidden = true
        
        
        UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            transitionImageView.frame = fromController.view.frame
        }) { (_) in
            transitionContext.completeTransition( !transitionContext.transitionWasCancelled )
            transitionImageView.removeFromSuperview()
            toController.view.isHidden = false
            toController.locationDetailsView.alpha = 1
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let viewHeight = toController.view.frame.height
                let weatherViewMaxY = toController.locationDetailsView.weatherView.frame.maxY
                let translationY = weatherViewMaxY + viewHeight * 0.05
                
                toController.closeButton.alpha = 1
                toController.locationDetailsView.transform = CGAffineTransform(translationX: 0, y: -translationY)
                toController.locationImageView.transform = CGAffineTransform(translationX: 0, y: -translationY / 2)
            })
        }
    }
}
