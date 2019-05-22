//
//  LocationViewController.swift
//  Thread
//
//  Created by Michael Onjack on 5/17/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?
    
    var location: Place!

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationDetailsView: ExploreLocationDetailsView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.alpha = 0
        
        location.getImage { (image) in
            self.locationImageView.image = image
        }
        
        locationDetailsView.nearbyItems = location.nearbyItems.filter { $0.1.itemImageUrl != nil || $0.1.smallItemImageUrl != nil }.shuffled()
        locationDetailsView.nameLabel.text = location.name

        locationDetailsView.weatherView.weatherImageView.image = location.weather.image
        locationDetailsView.weatherView.weatherDescriptionLabel.text = location.weather.description
        locationDetailsView.weatherView.temperatureView.itemLabel.text = "Temperature:\n" + String(location.temperature) + "° F"
        locationDetailsView.weatherView.humidityView.itemLabel.text = "Humidity:\n" + String(location.humidity) + "%"
        locationDetailsView.weatherView.windSpeedView.itemLabel.text = "Wind Speed:\n" + String(location.windSpeed) + " mph"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Don't allow the back swipe gesture in the Location controller
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Re-enable the navigation controller's back swipe gesture before leaving
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
