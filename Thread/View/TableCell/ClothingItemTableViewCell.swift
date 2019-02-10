//
//  ImageTableViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

protocol ClothingItemTableCellDelegate: AnyObject {
    func viewClothingItem(at cell: ClothingItemTableViewCell)
    func selectClothingItem(at cell: ClothingItemTableViewCell)
}

class ClothingItemTableViewCell: UITableViewCell {
    
    weak var delegate: ClothingItemTableCellDelegate?
    
    var itemImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    var blurDetailView: UIVisualEffectView = {
        let v = UIVisualEffectView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        v.alpha = 0
        
        return v
    }()
    
    var detailStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 16
        sv.backgroundColor = .clear
        sv.alpha = 0
        
        return sv
    }()
    
    var itemNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        
        return label
    }()
    
    var buttonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.backgroundColor = .clear
        sv.spacing = 16
        
        return sv
    }()
    
    var viewButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("View", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    
    var selectButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Select", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        
        return button
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

    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewButton.layer.cornerRadius = viewButton.frame.height / 6.0
        viewButton.clipsToBounds = true
        
        selectButton.layer.cornerRadius = selectButton.frame.height / 6.0
        selectButton.clipsToBounds = true
    }

    fileprivate func setupView() {
        
        selectionStyle = .none
        
        viewButton.addTarget(self, action: #selector(viewItem), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(selectItem), for: .touchUpInside)
        
        buttonsStackView.addArrangedSubview(viewButton)
        buttonsStackView.addArrangedSubview(selectButton)
        
        detailStackView.addArrangedSubview(itemNameLabel)
        detailStackView.addArrangedSubview(buttonsStackView)
        
        addSubview(itemImageView)
        addSubview(blurDetailView)
        addSubview(detailStackView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: topAnchor),
            itemImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            blurDetailView.topAnchor.constraint(equalTo: topAnchor),
            blurDetailView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurDetailView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurDetailView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            detailStackView.centerXAnchor.constraint(equalTo: blurDetailView.centerXAnchor),
            detailStackView.centerYAnchor.constraint(equalTo: blurDetailView.centerYAnchor),
            detailStackView.heightAnchor.constraint(equalTo: blurDetailView.heightAnchor, multiplier: 0.4),
            detailStackView.widthAnchor.constraint(equalTo: blurDetailView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    @objc func viewItem() {
        delegate?.viewClothingItem(at: self)
    }
    
    @objc func selectItem() {
        delegate?.selectClothingItem(at: self)
    }
}
