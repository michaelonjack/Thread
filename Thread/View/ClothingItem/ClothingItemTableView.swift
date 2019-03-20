//
//  ClothingItemTableView.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 300
        register(ClothingItemTableViewCell.self, forCellReuseIdentifier: "ClothingItemTableCell")
    }
}
