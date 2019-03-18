//
//  ClothingItemTableViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemTableViewCell: UITableViewCell {
    
    weak var delegate: ClothingItemTableCellDelegate?
    
    var clothingItemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    var itemNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .left
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .black
        l.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        l.numberOfLines = 0
        
        return l
    }()
    
    var buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.spacing = 8
        
        return sv
    }()
    
    var favoriteButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "Favorite"), for: .normal)
        b.setImage(UIImage(named: "FavoriteClicked"), for: UIControl.State.selected)
        b.imageView?.contentMode = .scaleAspectFit
        
        return b
    }()
    
    var viewInBrowserButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "Browser"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        
        return b
    }()
    
    var clothingItemImageHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        selectionStyle = .none
        
        viewInBrowserButton.addTarget(self, action: #selector(viewItem), for: .touchUpInside)
        
        buttonsStackView.addArrangedSubview(favoriteButton)
        buttonsStackView.addArrangedSubview(viewInBrowserButton)
        
        addSubview(clothingItemImageView)
        addSubview(itemNameLabel)
        addSubview(buttonsStackView)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        // Lower the priority of the top constraint to prevent the logger from whining during layout
        let buttonsStackViewBottomConstraint = buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        buttonsStackViewBottomConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            clothingItemImageView.topAnchor.constraint(equalTo: topAnchor),
            clothingItemImageView.bottomAnchor.constraint(equalTo: itemNameLabel.topAnchor, constant: -16),
            clothingItemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            clothingItemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            itemNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            itemNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            itemNameLabel.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -10),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            buttonsStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            buttonsStackView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05),
            buttonsStackViewBottomConstraint
        ])
    }
    
    func setClothingItemImage(image: UIImage) {
        if let imageHeightConstraint = clothingItemImageHeightConstraint {
            imageHeightConstraint.isActive = false
        }
        
        let aspectRatio = image.size.height / image.size.width
        
        clothingItemImageHeightConstraint = clothingItemImageView.heightAnchor.constraint(equalTo: clothingItemImageView.widthAnchor, multiplier: aspectRatio)
        clothingItemImageHeightConstraint?.priority = UILayoutPriority(rawValue: 999)
        clothingItemImageHeightConstraint?.isActive = true
        layoutIfNeeded()
        
        clothingItemImageView.image = image
    }
    
    @objc func viewItem() {
        delegate?.viewClothingItem(at: self)
    }
}
