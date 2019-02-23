//
//  SettingsTableViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/22/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        l.textColor = .white
        l.textAlignment = .left
        
        return l
    }()
    
    var valueLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        l.textColor = .white
        l.textAlignment = .right
        
        return l
    }()
    
    var rightArrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "RightArrow")
        
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        backgroundColor = UIColor(red: 0.368627451, green: 0.368627451, blue: 0.368627451, alpha: 1)
        
        addSubview(nameLabel)
        addSubview(valueLabel)
        addSubview(rightArrowImageView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            
            valueLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            valueLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor),
            
            rightArrowImageView.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 8),
            rightArrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            rightArrowImageView.heightAnchor.constraint(equalTo: rightArrowImageView.widthAnchor),
            rightArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
