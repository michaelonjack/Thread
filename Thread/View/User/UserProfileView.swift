//
//  UserProfileView.swift
//  Thread
//
//  Created by Michael Onjack on 6/4/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserProfileView: UIView {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.isExclusiveTouch = false
        sv.delaysContentTouches = false
        sv.showsVerticalScrollIndicator = false
        
        return sv
    }()
    
    let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    let picturesView: UserProfilePicturesView = {
        let pv = UserProfilePicturesView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        
        return pv
    }()
    
    let picturesViewGradientLayer: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.7).cgColor]
        gl.locations = [0.7, 1.1]
        
        return gl
    }()
    
    let statsView: UserProfileStatsView = {
        let sv = UserProfileStatsView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    let summaryView: UserProfileSummaryView = {
        let sv = UserProfileSummaryView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    let closetView: UserProfileFeedView = {
        let cv = UserProfileFeedView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    let followButton: CollapsibleButton = {
        let followButton = CollapsibleButton()
        followButton.selectedTitle = "Following"
        followButton.deselectedTitle = "Follow"
        followButton.button.setTitle("Follow", for: .normal)
        followButton.collapsedIcon = UIImage(named: "Check")!
        
        return followButton
    }()
    
    let blockButton: CollapsibleButton = {
        let blockButton = CollapsibleButton()
        blockButton.selectedTitle = "Blocked"
        blockButton.deselectedTitle = "Block"
        blockButton.button.setTitle("Block", for: .normal)
        blockButton.collapsedIcon = UIImage(named: "Block")!
        
        return blockButton
    }()
    
    let buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 24
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        sv.isLayoutMarginsRelativeArrangement = true
        
        return sv
    }()
    
    var buttonsStackViewHeightConstraintVisible: NSLayoutConstraint!
    var buttonsStackViewHeightConstraintHidden: NSLayoutConstraint!
    var buttonsStackViewTopConstraintVisible: NSLayoutConstraint!
    var buttonsStackViewTopConstraintHidden: NSLayoutConstraint!
    
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
        
        picturesViewGradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
    }
    
    fileprivate func setupView() {
        
        buttonsStackView.addArrangedSubview(blockButton)
        buttonsStackView.addArrangedSubview(followButton)
        
        picturesView.layer.addSublayer(picturesViewGradientLayer)
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(picturesView)
        contentView.addSubview(statsView)
        contentView.addSubview(summaryView)
        contentView.addSubview(closetView)
        contentView.addSubview(buttonsStackView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        buttonsStackViewTopConstraintVisible = buttonsStackView.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 16)
        buttonsStackViewTopConstraintHidden = buttonsStackView.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 0)
        buttonsStackViewHeightConstraintVisible = buttonsStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04)
        buttonsStackViewHeightConstraintHidden = buttonsStackView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            picturesView.topAnchor.constraint(equalTo: contentView.topAnchor),
            picturesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            picturesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            picturesView.widthAnchor.constraint(equalTo: widthAnchor),
            picturesView.heightAnchor.constraint(equalTo: picturesView.widthAnchor),
            
            statsView.leadingAnchor.constraint(equalTo: picturesView.leadingAnchor),
            statsView.trailingAnchor.constraint(equalTo: picturesView.trailingAnchor),
            statsView.bottomAnchor.constraint(equalTo: picturesView.bottomAnchor),
            statsView.heightAnchor.constraint(equalTo: picturesView.heightAnchor, multiplier: 0.22),
            
            summaryView.topAnchor.constraint(equalTo: picturesView.bottomAnchor),
            summaryView.leadingAnchor.constraint(equalTo: picturesView.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: picturesView.trailingAnchor, constant: -16),
            summaryView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: picturesView.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: picturesView.trailingAnchor),
            buttonsStackViewTopConstraintVisible,
            buttonsStackViewHeightConstraintVisible,
            
            closetView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 16),
            closetView.leadingAnchor.constraint(equalTo: picturesView.leadingAnchor, constant: 16),
            closetView.trailingAnchor.constraint(equalTo: picturesView.trailingAnchor),
            closetView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            closetView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func hideButtonsStackView() {
        buttonsStackViewTopConstraintVisible.isActive = false
        buttonsStackViewHeightConstraintVisible.isActive = false
        buttonsStackViewTopConstraintHidden.isActive = true
        buttonsStackViewHeightConstraintHidden.isActive = true
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
    }
}
