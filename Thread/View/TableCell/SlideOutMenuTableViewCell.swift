//
//  SlideOutMenuTableViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/16/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SlideOutMenuTableViewCell: UITableViewCell {
    
    var optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        
        return iv
    }()
    
    var optionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
        
        return l
    }()
    
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
        addSubview(optionImageView)
        addSubview(optionLabel)
        
        selectionStyle = .none
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            optionImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            optionImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15),
            optionImageView.heightAnchor.constraint(equalTo: optionImageView.widthAnchor),
            optionImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            optionLabel.topAnchor.constraint(equalTo: optionImageView.topAnchor),
            optionLabel.bottomAnchor.constraint(equalTo: optionImageView.bottomAnchor),
            optionLabel.leadingAnchor.constraint(equalTo: optionImageView.trailingAnchor, constant: 24),
            optionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
