//
//  UserMapAnnotationView.swift
//  Thread
//
//  Created by Michael Onjack on 2/20/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import MapKit

class UserMapAnnotationView: MKAnnotationView {
    
    var profilePictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3
        
        return iv
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height / 2
    }
    
    fileprivate func setupView() {
        
        addSubview(profilePictureImageView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            profilePictureImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePictureImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profilePictureImageView.heightAnchor.constraint(equalToConstant: 80),
            profilePictureImageView.widthAnchor.constraint(equalTo: profilePictureImageView.heightAnchor)
        ])
    }
}
