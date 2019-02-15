//
//  UserTableViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var userPictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    var userDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var closetImagesSwipeViewContainer: SwipeViewContainer {
        let swipeViewContainer = SwipeViewContainer()
        swipeViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return swipeViewContainer
    }
    
    var topSwipeView: ClothingItemSwipeView?
    var bottomSwipeView: ClothingItemSwipeView?
    var shoesSwipeView: ClothingItemSwipeView?
    var accessoriesSwipeView: ClothingItemSwipeView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    fileprivate func setupView() {
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
    }
}
