//
//  HomeFollowingView.swift
//  Thread
//
//  Created by Michael Onjack on 6/30/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeFollowingView: UIView {
    
    var pullIndicator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        v.clipsToBounds = true
        v.layer.cornerRadius = 4
        
        return v
    }()
    
    var usersHeaderView: HomeFollowingUsersView = {
        let v = HomeFollowingUsersView()
        
        return v
    }()
    
    var itemsTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .singleLine
        tv.backgroundColor = .white
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 1500
        tv.showsVerticalScrollIndicator = false
        tv.register(UserClothingItemTableViewCell.self, forCellReuseIdentifier: "UserClothingItemCell")
        
        return tv
    }()
    
    var pullIndicatorHeightConstraint: NSLayoutConstraint!
    var pullIndicatorTopConstraint: NSLayoutConstraint!
    var pullIndicatorBottomConstraint: NSLayoutConstraint!
    var pullIndicatorHeightConstant: CGFloat = 8
    var pullIndicatorTopConstant: CGFloat = 16
    var pullIndicatorBottomConstant: CGFloat = 8
    var cornerRadiusSet = false
    
    var initialVisibleHeight: CGFloat!
    
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
        
        if !cornerRadiusSet {
            cornerRadiusSet = true
            
            layer.cornerRadius = frame.height / 10
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    fileprivate func setupView() {
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        clipsToBounds = true
        
        addSubview(pullIndicator)
        addSubview(itemsTableView)
        
        setupLayout()
        
        // Determine the height of the "New Items" label
        let constraintRect = CGSize(width: 1000, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = "New Items".boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)], context: nil)
        
        let labelHeight: CGFloat =  boundingBox.height
        let labelTopSpacing: CGFloat = 8
        
        initialVisibleHeight = pullIndicatorHeightConstant + pullIndicatorTopConstant + pullIndicatorBottomConstant + 150 - labelHeight - labelTopSpacing
    }
    
    fileprivate func setupLayout() {
        
        pullIndicatorHeightConstraint = pullIndicator.heightAnchor.constraint(equalToConstant: pullIndicatorHeightConstant)
        pullIndicatorTopConstraint = pullIndicator.topAnchor.constraint(equalTo: topAnchor, constant: pullIndicatorTopConstant)
        pullIndicatorBottomConstraint = itemsTableView.topAnchor.constraint(equalTo: pullIndicator.bottomAnchor, constant: pullIndicatorBottomConstant)
        
        NSLayoutConstraint.activate([
            pullIndicatorTopConstraint,
            pullIndicatorHeightConstraint,
            pullIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            pullIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pullIndicatorBottomConstraint,
            itemsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
