//
//  HomeViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/16/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import TabbedPageView

class HomeViewController: SlideOutMenuViewController, Storyboarded {

    @IBOutlet weak var tabbedPageView: TabbedPageView!
    @IBOutlet var exploreView: ExploreMainView!
    @IBOutlet var aroundMeView: AroundMeView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aroundMeView.mapView.delegate = self
        
        updateUserLocation()
        
        setupTabbedPageView()
    }
    
    fileprivate func setupTabbedPageView() {
        tabbedPageView.isManualScrollingEnabled = false
        tabbedPageView.tabBar.position = .bottom
        tabbedPageView.tabBar.sliderColor = .black
        tabbedPageView.tabBar.transitionStyle = .sticky
        tabbedPageView.tabBar.height = 60
        
        tabbedPageView.delegate = self
        tabbedPageView.dataSource = self
        tabbedPageView.reloadData()
    }
    
    fileprivate func updateUserLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}



extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        guard let currentUser = configuration.currentUser else { return }
        
        manager.stopUpdatingLocation()
        
        // Update user's location
        currentUser.location = location
        currentUser.save()
        
        // Set the initial map region
        let mapRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 0.025, longitudinalMeters: 0.025)
        aroundMeView.mapView.setRegion(mapRegion, animated: true)
        
        // Add annotation for the current user
        let userAnnotation = UserMapAnnotation(user: currentUser)
        userAnnotation.coordinate = location.coordinate
        aroundMeView.mapView.addAnnotation(userAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let userAnnotation = annotation as? UserMapAnnotation else { return nil }
        guard let annotationView = aroundMeView.mapView.dequeueReusableAnnotationView(withIdentifier: "UserAnnotation") as? UserMapAnnotationView else { return nil }
        
        let callOutView = UserMapAnnotationCallOutView()
        callOutView.nameLabel.text = userAnnotation.user.name
        callOutView.lastCheckedInLabel.text = "Last checked in: " + userAnnotation.user.lastCheckInStr
        callOutView.userId = userAnnotation.user.uid
        callOutView.delegate = self
        
        userAnnotation.user.getProfilePicture { (profilePicture) in
            DispatchQueue.main.async {
                annotationView.profilePictureImageView.image = profilePicture
                callOutView.profilePictureImageView.image = profilePicture
            }
        }
        
        annotationView.canShowCallout = true
        annotationView.detailCalloutAccessoryView = callOutView
        
        return annotationView
    }
}



extension HomeViewController: UserMapAnnotationDelegate {
    func viewButtonPressed(userId: String) {
        coordinator?.viewUserProfile(userId: userId)
    }
}



extension HomeViewController: TabbedPageViewDelegate {
    
}



extension HomeViewController: TabbedPageViewDataSource {
    
    var tabs: [Tab] {
        
        let tabAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 14)!
        ]
        
        let blueView = UIView()
        blueView.backgroundColor = .ultraLightBlue
        
        let greenView = UIView()
        greenView.backgroundColor = .ultraLightGreen
        
        return [
            Tab(view: exploreView, type: .attributedText(NSAttributedString(string: "EXPLORE", attributes: tabAttributes))),
            Tab(view: blueView, type: .attributedText(NSAttributedString(string: "HOME", attributes: tabAttributes))),
            Tab(view: aroundMeView, type: .attributedText(NSAttributedString(string: "AROUND ME", attributes: tabAttributes)))
        ]
    }
    
    func tabbedPageView(_ tabbedPageView: TabbedPageView, tabForIndex index: Int) -> Tab {
        return tabs[index]
    }
    
    func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int {
        return tabs.count
    }
}
