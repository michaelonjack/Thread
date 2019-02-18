//
//  ExploreMainView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreMainView: UIView {
    
    var zipCodeSearchBarView: SearchBarView = {
        let searchView = SearchBarView(frame: .zero)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        return searchView
    }()
    
    var locationsView: ExploreLocationsView = {
        let locationsView = ExploreLocationsView(frame: .zero)
        locationsView.translatesAutoresizingMaskIntoConstraints = false
        
        return locationsView
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
        
        zipCodeSearchBarView.searchBarView.textField.placeholder = "search zip code"
        
        addSubview(zipCodeSearchBarView)
        addSubview(locationsView)
        
        setupLayout()
        
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            zipCodeSearchBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            zipCodeSearchBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            zipCodeSearchBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            zipCodeSearchBarView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            locationsView.topAnchor.constraint(equalTo: zipCodeSearchBarView.bottomAnchor),
            locationsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationsView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
