//
//  HomeFollowingView.swift
//  Thread
//
//  Created by Michael Onjack on 6/30/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeFollowingView: UIView {
    
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
            
            layer.cornerRadius = frame.height / 16
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    fileprivate func setupView() {
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        clipsToBounds = true
        
        itemsTableView.tableHeaderView = usersHeaderView
        
        addSubview(itemsTableView)
        
        setupLayout()
        
        // Determine the height of the "New Items" label
        let constraintRect = CGSize(width: 1000, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = "New Items".boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)], context: nil)
        
        let labelHeight: CGFloat =  boundingBox.height
        let labelTopSpacing: CGFloat = 8
        
        initialVisibleHeight = usersHeaderView.height - labelHeight - labelTopSpacing
    }
    
    fileprivate func setupLayout() {
        
        NSLayoutConstraint.activate([
            itemsTableView.topAnchor.constraint(equalTo: topAnchor),
            itemsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
