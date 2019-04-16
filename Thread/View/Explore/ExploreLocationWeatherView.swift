//
//  ExploreLocationWeatherView.swift
//  Thread
//
//  Created by Michael Onjack on 4/15/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreLocationWeatherView: UIView {
    
    var weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    var weatherDescriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Regular", size: 25.0)
        l.textColor = .black
        l.textAlignment = .left
        l.numberOfLines = 2
        
        return l
    }()
    
    var weatherDetailsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.spacing = 8
        
        return sv
    }()
    
    var temperatureView: ExploreLocationWeatherItemView = {
        let v = ExploreLocationWeatherItemView()
        v.itemImageView.image = UIImage(named: "Thermometer")
        
        return v
    }()
    
    var humidityView: ExploreLocationWeatherItemView = {
        let v = ExploreLocationWeatherItemView()
        v.itemImageView.image = UIImage(named: "Humidity")
        
        return v
    }()
    
    var windSpeedView: ExploreLocationWeatherItemView = {
        let v = ExploreLocationWeatherItemView()
        v.itemImageView.image = UIImage(named: "Wind")
        
        return v
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
        
        weatherDetailsStackView.addArrangedSubview(temperatureView)
        weatherDetailsStackView.addArrangedSubview(humidityView)
        weatherDetailsStackView.addArrangedSubview(windSpeedView)
        
        addSubview(weatherImageView)
        addSubview(weatherDescriptionLabel)
        addSubview(weatherDetailsStackView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            weatherImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor),
            
            weatherDescriptionLabel.centerYAnchor.constraint(equalTo: weatherImageView.centerYAnchor),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 16),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            weatherDetailsStackView.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 16),
            weatherDetailsStackView.leadingAnchor.constraint(equalTo: weatherImageView.leadingAnchor),
            weatherDetailsStackView.trailingAnchor.constraint(equalTo: weatherDescriptionLabel.trailingAnchor),
            weatherDetailsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
