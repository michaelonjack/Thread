//
//  HomeFollowingItemsView.swift
//  Thread
//
//  Created by Michael Onjack on 3/10/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class HomeFollowingItemsView: UIView {
    
    var itemsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.text = "New Items"
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        l.textAlignment = .left
        
        return l
    }()
    
    var followingItemsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .singleLine
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 1500
        tv.register(UserClothingItemTableViewCell.self, forCellReuseIdentifier: "UserClothingItemCell")
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        backgroundColor = .white
        
        addSubview(itemsLabel)
        addSubview(followingItemsTableView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            itemsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            itemsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            itemsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            followingItemsTableView.topAnchor.constraint(equalTo: itemsLabel.bottomAnchor),
            followingItemsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            followingItemsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            followingItemsTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
