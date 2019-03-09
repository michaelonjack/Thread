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
        b.setImage(UIImage(named: "ShowMore"), for: .normal)
        
        return b
    }()
    
    var closetButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "Closet"), for: .normal)
        
        return b
    }()
    
    var revealView: HomeRevealView = {
        let v = HomeRevealView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0
        
        return v
    }()
    
    var topView: HomeTopView = {
        let v = HomeTopView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var bottomView: HomeBottomView = {
        let v = HomeBottomView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    var topViewTrailingAnchor: NSLayoutConstraint!
    var bottomViewLeadingAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        addSubview(revealView)
        addSubview(showMenuButton)
        addSubview(closetButton)
        addSubview(topView)
        addSubview(bottomView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        topViewTrailingAnchor = topView.trailingAnchor.constraint(equalTo: trailingAnchor)
        bottomViewLeadingAnchor = bottomView.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        NSLayoutConstraint.activate([
            revealView.topAnchor.constraint(equalTo: showMenuButton.bottomAnchor),
            revealView.bottomAnchor.constraint(equalTo: bottomAnchor),
            revealView.leadingAnchor.constraint(equalTo: leadingAnchor),
            revealView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            showMenuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            showMenuButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            showMenuButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            showMenuButton.widthAnchor.constraint(equalTo: showMenuButton.heightAnchor),
            
            closetButton.topAnchor.constraint(equalTo: showMenuButton.topAnchor),
            closetButton.bottomAnchor.constraint(equalTo: showMenuButton.bottomAnchor),
            closetButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closetButton.widthAnchor.constraint(equalTo: closetButton.heightAnchor),
            
            topViewTrailingAnchor,
            topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.18),
            topView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.98),
            topView.topAnchor.constraint(equalTo: showMenuButton.bottomAnchor, constant: 5),
            
            bottomViewLeadingAnchor,
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
            bottomView.widthAnchor.constraint(equalTo: topView.widthAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    func revealBackgroundView() {
        topViewTrailingAnchor.isActive = false
        bottomViewLeadingAnchor.isActive = false
        
        topViewTrailingAnchor = topView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: topView.frame.width - 20)
        bottomViewLeadingAnchor = bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1 * bottomView.frame.width + 20)
        
        topViewTrailingAnchor.isActive = true
        bottomViewLeadingAnchor.isActive = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.revealView.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    func hideBackgroundView() {
        topViewTrailingAnchor.isActive = false
        bottomViewLeadingAnchor.isActive = false
        
        topViewTrailingAnchor = topView.trailingAnchor.constraint(equalTo: trailingAnchor)
        bottomViewLeadingAnchor = bottomView.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        topViewTrailingAnchor.isActive = true
        bottomViewLeadingAnchor.isActive = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.revealView.alpha = 0
            self.layoutIfNeeded()
        })
    }
}
