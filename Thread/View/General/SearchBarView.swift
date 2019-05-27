//
//  ClothingItemSearchBar.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    
    var searchBar: UnderlinedTextFieldView = {
        let field = UnderlinedTextFieldView(contentType: UITextContentType.name, placeHolder: "search")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textField.autocapitalizationType = UITextAutocapitalizationType.none
        field.textField.textAlignment = .left
        
        return field
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        return button
    }()
    
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
        
        searchButton.layer.cornerRadius = searchButton.frame.height / 6.0
        searchButton.clipsToBounds = true
    }
    
    fileprivate func setupView() {
        
        addSubview(searchBar)
        addSubview(searchButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.60),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor, multiplier: 0.70),
            searchButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
