//
//  AroundMeTableHeaderView.swift
//  Thread
//
//  Created by Michael Onjack on 2/20/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import MapKit

class AroundMeView: UIView {
    
    var mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.register(UserMapAnnotationView.self, forAnnotationViewWithReuseIdentifier: "UserAnnotation")
        
        return mv
    }()
    
    var refreshButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "Reload"), for: .normal)
        
        return b
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
        
        addSubview(mapView)
        addSubview(refreshButton)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            refreshButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            refreshButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            refreshButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            refreshButton.widthAnchor.constraint(equalTo: refreshButton.heightAnchor)
        ])
    }
}
