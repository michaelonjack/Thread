//
//  SlideOutMenuViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/16/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SlideOutMenuViewController: UIViewController {
    
    weak var coordinator: ActiveUserCoordinator?
    
    var darkCoverView: UIView!
    var slideOutMenu: SlideOutMenuView!
    var slideOutMenuTrailingAnchor: NSLayoutConstraint!
    var openMenuPanGesture: UIScreenEdgePanGestureRecognizer!
    var closeMenuPanGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDarkCoverView()
        setupSlideOutMenu()
        
        openMenuPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan))
        openMenuPanGesture.edges = .left
        openMenuPanGesture.delegate = self
        view.addGestureRecognizer(openMenuPanGesture)
        
        closeMenuPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        closeMenuPanGesture.delegate = self
        view.addGestureRecognizer(closeMenuPanGesture)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // Hide the slide out menu
        if let firstTouch = touches.first, slideOutMenu.isOpen {
            let tappedView = view.hitTest(firstTouch.location(in: view), with: event)
            
            if tappedView != slideOutMenu {
                closeMenu()
            }
        }
    }
    
    fileprivate func setupSlideOutMenu() {
        let menuWidth = min(400, view.frame.width * 0.75)
        slideOutMenu = SlideOutMenuView(ofWidth: menuWidth)
        slideOutMenu.translatesAutoresizingMaskIntoConstraints = false
        slideOutMenu.delegate = self
        
        view.addSubview(slideOutMenu)
        
        slideOutMenuTrailingAnchor = slideOutMenu.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        
        NSLayoutConstraint.activate([
            slideOutMenu.topAnchor.constraint(equalTo: view.topAnchor),
            slideOutMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            slideOutMenu.widthAnchor.constraint(equalToConstant: slideOutMenu.menuWidth),
            slideOutMenuTrailingAnchor
        ])
    }
    
    fileprivate func setupDarkCoverView() {
        darkCoverView = UIView()
        darkCoverView.translatesAutoresizingMaskIntoConstraints = false
        darkCoverView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        darkCoverView.alpha = 0
        
        view.addSubview(darkCoverView)
        
        NSLayoutConstraint.activate([
            darkCoverView.topAnchor.constraint(equalTo: view.topAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        var translationX = gesture.translation(in: view).x
        let velocityX = gesture.velocity(in: view).x
        
        switch gesture.state {
        case .changed:
            
            translationX = slideOutMenu.isOpen ? translationX + slideOutMenu.menuWidth : translationX
            translationX = min(translationX, slideOutMenu.menuWidth)
            translationX = max(translationX, 0)
            
            slideOutMenuTrailingAnchor.constant = translationX
            darkCoverView.alpha = translationX / slideOutMenu.menuWidth
            
        case .ended:
            if slideOutMenu.isOpen {
                if velocityX < -600 {
                    closeMenu()
                    return
                }
                
                if abs(translationX) < slideOutMenu.menuWidth / 2 {
                    openMenu()
                } else {
                    closeMenu()
                }
            } else {
                if velocityX > 600 {
                    openMenu()
                    return
                }
                
                if translationX < slideOutMenu.menuWidth / 2 {
                    closeMenu()
                } else {
                    openMenu()
                }
            }
        default:
            break
        }
    }
    
    func openMenu() {
        slideOutMenu.isOpen = true
        slideOutMenuTrailingAnchor.constant = slideOutMenu.menuWidth
        animateSlideOutMenu()
    }
    
    func closeMenu() {
        slideOutMenu.isOpen = false
        slideOutMenuTrailingAnchor.constant = 0
        animateSlideOutMenu()
    }
    
    func animateSlideOutMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.darkCoverView.alpha = self.slideOutMenu.isOpen ? 1 : 0
        })
    }
}



extension SlideOutMenuViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // Only concerned with coordinating between the different existing pan gestures
        if !(gestureRecognizer is UIPanGestureRecognizer) || !(otherGestureRecognizer is UIPanGestureRecognizer) {
            return false
        }
        
        // If the gesture is the openMenuPanGesture (screen edge pan gesture) or if the slide out menu is already open, the slide out menu pan gestures should receive priority
        if gestureRecognizer == openMenuPanGesture || slideOutMenu.isOpen {
            return true
        }
        
        return false
    }
}



extension SlideOutMenuViewController: SlideOutMenuDelegate {
    func didSelectProfileOption() {
        guard let currentUser = configuration.currentUser else { return }
        
        coordinator?.viewUserProfile(userId: currentUser.uid)
    }
    
    func didSelectFollowingOption() {
        guard let currentUser = configuration.currentUser else { return }
        
        coordinator?.viewFollowedUsers(for: currentUser)
    }
    
    func didSelectFavoritesOption() {
        guard let currentUser = configuration.currentUser else { return }
        
        coordinator?.viewFavoritedItems(for: currentUser)
    }
    
    func didSelectSettingsOption() {
        coordinator?.viewSettings()
    }
    
    
}
