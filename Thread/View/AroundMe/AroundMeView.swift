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
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
