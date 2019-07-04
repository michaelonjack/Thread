//
//  HomeView.swift
//  Thread
//
//  Created by Michael Onjack on 3/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    var showMenuButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "Menu"), for: .normal)
        
        return b
    }()
    
    var profileButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "Avatar"), for: .normal)
        b.backgroundColor = .lightGray
        b.clipsToBounds = true
        b.imageView?.contentMode = .scaleAspectFill
        
        return b
    }()
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .black
        l.backgroundColor = .white
        l.font = UIFont(name: "AvenirNext-Medium", size: 35.0)
        l.textAlignment = .center
        
        return l
    }()
    
    var locationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .black
        l.backgroundColor = .white
        l.font = UIFont(name: "AvenirNext-Medium", size: 25.0)
        l.textAlignment = .center
        
        return l
    }()
    
    var hideLocationButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .black
        b.setTitle("Hide Location", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.clipsToBounds = true
        
        return b
    }()
    
    var checkInButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .black
        b.setTitle("Check In", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.clipsToBounds = true
        
        return b
    }()
    
    var buttonsStackView: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.spacing = 8
        
        return sv
    }()
    
    var followingView: HomeFollowingView = {
        let hfv = HomeFollowingView()
        hfv.translatesAutoresizingMaskIntoConstraints = false
        
        return hfv
    }()
    
    var profileButtonBottomConstraint: NSLayoutConstraint!
    var profileButtonCenterXConstraint: NSLayoutConstraint!
    var profileButtonHeightConstraint: NSLayoutConstraint!
    var profileButtonWidthConstraint: NSLayoutConstraint!
    var profilePictureButtonAnimator: UIViewPropertyAnimator!
    // Y position in the frame where the animator should begin
    var animationStartY: CGFloat!
    // Y position in the frame where the animator should stop
    var animationEndY: CGFloat!
    var maxYReached = false
    
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
        
        profileButton.layer.cornerRadius = profileButton.frame.height / 2.0
        checkInButton.layer.cornerRadius = buttonsStackView.frame.height / 5.0
        hideLocationButton.layer.cornerRadius = buttonsStackView.frame.height / 5.0
        
        if animationStartY == nil {
            animationStartY = profileButton.frame.maxY + 8
            animationEndY = showMenuButton.frame.maxY
        }
    }
    
    fileprivate func setupView() {
        
        clipsToBounds = true
        
        setupPropertyAnimator()
        setupGestureRecognizers()
        
        buttonsStackView.addArrangedSubview(hideLocationButton)
        buttonsStackView.addArrangedSubview(checkInButton)
        
        addSubview(showMenuButton)
        addSubview(profileButton)
        addSubview(nameLabel)
        addSubview(locationLabel)
        addSubview(buttonsStackView)
        addSubview(followingView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        profileButtonBottomConstraint = profileButton.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8)
        profileButtonWidthConstraint = profileButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        profileButtonHeightConstraint = profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor)
        profileButtonCenterXConstraint = profileButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        NSLayoutConstraint.activate([
            showMenuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            showMenuButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            showMenuButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            showMenuButton.widthAnchor.constraint(equalTo: showMenuButton.heightAnchor),
            
            profileButtonCenterXConstraint,
            profileButtonBottomConstraint,
            profileButtonWidthConstraint,
            profileButtonHeightConstraint,
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            
            buttonsStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            buttonsStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07),
            
            followingView.topAnchor.constraint(equalTo: bottomAnchor, constant: -followingView.initialVisibleHeight),
            followingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            followingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            followingView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.885)
        ])
    }
    
    fileprivate func setupPropertyAnimator() {
        profilePictureButtonAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: { [weak self] in
            guard let sself = self else { return }
            
            // Deactivate the start position constraints
            sself.profileButtonBottomConstraint.isActive = false
            sself.profileButtonCenterXConstraint.isActive = false
            sself.profileButtonHeightConstraint.isActive = false
            sself.profileButtonWidthConstraint.isActive = false
            
            // Activate the end position constraints
            NSLayoutConstraint.activate([
                sself.profileButton.topAnchor.constraint(equalTo: sself.showMenuButton.topAnchor),
                sself.profileButton.bottomAnchor.constraint(equalTo: sself.showMenuButton.bottomAnchor),
                sself.profileButton.widthAnchor.constraint(equalTo: sself.profileButton.heightAnchor),
                sself.profileButton.trailingAnchor.constraint(equalTo: sself.trailingAnchor, constant: -8),
            ])
            
            sself.followingView.layer.cornerRadius = 0
            sself.followingView.backgroundColor = .white
            sself.followingView.usersHeaderView.backgroundColor = .white
            
            // Make the constraint changes take effect
            sself.layoutIfNeeded()
        })
        profilePictureButtonAnimator.pausesOnCompletion = true
    }
    
    fileprivate func setupGestureRecognizers() {
        
        let followingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        followingViewPanGesture.delegate = self
        
        followingView.addGestureRecognizer(followingViewPanGesture)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            break
        case .changed:
            // Don't allow the panned view to go lower than the view's bottom
            if followingView.frame.minY + followingView.initialVisibleHeight + translation.y >= frame.maxY {
                return
            }
            
            // Don't allow the panned view to go above the top bar
            else if followingView.frame.minY + translation.y <= animationEndY {
                maxYReached = true
                return
            }
            
            // Don't allow the pan to occur if we're currently scrolling the table view
            else if followingView.itemsTableView.contentOffset.y != 0.0 {
                gesture.setTranslation(CGPoint.zero, in: self)
                return
            }
            
            maxYReached = false
            
            // Move the pannable views with the pan gesture
            followingView.transform = followingView.transform.translatedBy(x: 0, y: translation.y)
            
            // Animate the position change of the profile picture button
            let percentComplete = (animationStartY - followingView.frame.minY) / (animationStartY - animationEndY)
            if percentComplete >= 0 && percentComplete <= 1 {
                profilePictureButtonAnimator.fractionComplete = percentComplete
                
                // Animate the shrinking of the pull indicator
                if let followingTableHeaderView = followingView.itemsTableView.tableHeaderView as? HomeFollowingUsersView {
                    followingTableHeaderView.pullIndicatorTopConstraint.constant = followingTableHeaderView.pullIndicatorTopConstant - (followingTableHeaderView.pullIndicatorTopConstant * percentComplete)
                    followingTableHeaderView.pullIndicatorHeightConstraint.constant = followingTableHeaderView.pullIndicatorHeightConstant - (followingTableHeaderView.pullIndicatorHeightConstant * percentComplete)
                    followingTableHeaderView.pullIndicatorBottomConstraint.constant =  followingTableHeaderView.pullIndicatorBottomConstant - (followingTableHeaderView.pullIndicatorBottomConstant * percentComplete)
                    followingView.usersHeaderView.followingUsersCollectionView.collectionViewLayout.invalidateLayout()
                }
            }
        default:
            break
        }
        
        gesture.setTranslation(CGPoint.zero, in: self)
    }
}



extension HomeView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        
        if gestureRecognizer.view != followingView {
            return true
        }
        
        // If we're panning on the Following Users View or the Following Items View, then the gesture only matters if it's in the vertical direction. Otherwise we might be try to open the slide out menu or trying to perform some other gesture
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        
        return abs(velocity.y) > abs(velocity.x)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let itemsTableView = followingView.itemsTableView
        
        if (gestureRecognizer.view == itemsTableView && otherGestureRecognizer.view == followingView)
            || (gestureRecognizer.view == followingView && otherGestureRecognizer.view == itemsTableView) {
            return true
        }
        
        return false
    }
}
