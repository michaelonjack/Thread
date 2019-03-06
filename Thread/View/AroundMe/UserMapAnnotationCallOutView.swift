//
//  UserMapAnnotationCallOutView.swift
//  Thread
//
//  Created by Michael Onjack on 2/21/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserMapAnnotationCallOutView: UIView {
    
    var profilePictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
        l.textColor = .black
        l.textAlignment = .center
        
        return l
    }()
    
    var lastCheckedInLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Regular", size: 12.0)
        l.textColor = .gray
        l.textAlignment = .center
        l.numberOfLines = 0
        
        return l
    }()
    
    var viewButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .black
        b.setTitle("View", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 15.0)
        b.clipsToBounds = true
        
        return b
    }()
    
    var userId: String!
    weak var delegate: UserMapAnnotationDelegate?
    
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
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height / 2
        viewButton.layer.cornerRadius = viewButton.frame.height / 5
    }
    
    fileprivate func setupView() {
        
        viewButton.addTarget(self, action: #selector(viewButtonPressed), for: .touchUpInside)
        
        addSubview(profilePictureImageView)
        addSubview(nameLabel)
        addSubview(lastCheckedInLabel)
        addSubview(viewButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            profilePictureImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            profilePictureImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePictureImageView.heightAnchor.constraint(equalToConstant: 60),
            profilePictureImageView.widthAnchor.constraint(equalTo: profilePictureImageView.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            lastCheckedInLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            lastCheckedInLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            lastCheckedInLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            viewButton.topAnchor.constraint(equalTo: lastCheckedInLabel.bottomAnchor, constant: 8),
            viewButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            viewButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            viewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    @objc func viewButtonPressed() {
        delegate?.viewButtonPressed(userId: userId)
    }
}
