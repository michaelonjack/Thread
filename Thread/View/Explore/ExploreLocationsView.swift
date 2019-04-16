//
//  ExploreLocationsView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreLocationsView: UIView {
    
    var locationsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.backgroundColor = .clear
        cv.register(ExploreLocationCollectionViewCell.self, forCellWithReuseIdentifier: "LocationCell")
        
        return cv
    }()
    
    var places: [Place] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        locationsCollectionView.delegate = self
        locationsCollectionView.dataSource = self
        
        getPlaces { (places) in
            configuration.places = places
            self.places = places
            
            for place in places {
                
                // Update the place's weather data if it's over 20 minutes since the last update
                if place.minutesSinceLastUpdate > 20 {
                    APIHelper.getCurrentWeather(for: place, completion: { (result) in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let weatherData):
                            place.updateWeather(using: weatherData)
                        }
                    })
                }
            }
            
            DispatchQueue.main.async {
                self.locationsCollectionView.reloadData()
            }
        }
        
        addSubview(locationsCollectionView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            locationsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            locationsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            locationsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}



extension ExploreLocationsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ExploreLocationCollectionViewCell else { return }
        guard let rootView = selectedCell.window?.subviews[0] else { return }
        
        
        let originInParent = selectedCell.convert(CGPoint(x: 0, y: 0), to: rootView)
        let frameInRootView = CGRect(x: originInParent.x, y: originInParent.y, width: selectedCell.frame.width, height: selectedCell.frame.height)
        
        let location = places[indexPath.row]
        let locationExpandedView = ExploreLocationExpandedView(frame: frameInRootView)
        locationExpandedView.translatesAutoresizingMaskIntoConstraints = false
        locationExpandedView.locationImageView.image = selectedCell.imageView.image
        locationExpandedView.detailsView.nameLabel.text = location.name
        
        locationExpandedView.detailsView.weatherView.weatherImageView.image = location.weather.image
        locationExpandedView.detailsView.weatherView.weatherDescriptionLabel.text = location.weather.description
        locationExpandedView.detailsView.weatherView.temperatureView.itemLabel.text = "Temperature:\n" + String(location.temperature) + "° F"
        locationExpandedView.detailsView.weatherView.humidityView.itemLabel.text = "Humidity:\n" + String(location.humidity) + "%"
        locationExpandedView.detailsView.weatherView.windSpeedView.itemLabel.text = "Wind Speed:\n" + String(location.windSpeed) + " mph"
        
        rootView.addSubview(locationExpandedView)
        locationExpandedView.animateOpening()
    }
}



extension ExploreLocationsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath)
        
        guard let imageCell = cell as? ExploreLocationCollectionViewCell else { return cell }
        
        let location = places[indexPath.row]
        imageCell.imageView.contentMode = .scaleAspectFill
        
        location.getImage { (image) in
            DispatchQueue.main.async {
                imageCell.imageView.image = image
            }
        }
        
        return imageCell
    }
    
    
}



extension ExploreLocationsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: collectionView.frame.height * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
