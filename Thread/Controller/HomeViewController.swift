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
import FirebaseDatabase

class HomeViewController: SlideOutMenuViewController, Storyboarded {

    @IBOutlet weak var tabbedPageView: TabbedPageView!
    @IBOutlet var exploreView: ExploreMainView!
    @IBOutlet var homeView: HomeView!
    @IBOutlet var aroundMeView: AroundMeView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aroundMeView.mapView.delegate = self
        
        updateUserLocation()
        
        setupTabbedPageView()
        setupAroundMeView()
        setupHomeView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func setupTabbedPageView() {
        tabbedPageView.tabBar.position = .bottom
        tabbedPageView.tabBar.sliderColor = .black
        tabbedPageView.tabBar.transitionStyle = .sticky
        tabbedPageView.tabBar.height = 50
        
        tabbedPageView.delegate = self
        tabbedPageView.dataSource = self
        tabbedPageView.reloadData()
    }
    
    fileprivate func setupAroundMeView() {
        aroundMeView.refreshButton.addTarget(self, action: #selector(refreshAroundMeMap), for: .touchUpInside)
    }
    
    fileprivate func setupHomeView() {
        homeView.showMenuButton.addTarget(self, action: #selector(showSlideOutMenu), for: .touchUpInside)
        homeView.closetButton.addTarget(self, action: #selector(revealHomeBackgroundView), for: .touchUpInside)
        homeView.revealView.doneButton.addTarget(self, action: #selector(hideHomeBackgroundView), for: .touchUpInside)
        
        getCurrentUser { (currentUser) in
            self.homeView.topView.nameLabel.text = currentUser.name
            
            currentUser.getProfilePicture(completion: { (profilePicture) in
                self.homeView.topView.profilePictureButton.setImage(profilePicture, for: .normal)
                
                // Cache the profile picture if it has not already been saved
                if let profilePicture = profilePicture, UserDefaults.standard.data(forKey: currentUser.uid + "-profilePicture") == nil {
                    UserDefaults.standard.setValue(profilePicture.jpegData(compressionQuality: 1), forKey: currentUser.uid + "-profilePicture")
                }
            })
            
            currentUser.getLocationStr(completion: { (locationStr) in
                self.homeView.topView.locationLabel.text = locationStr
            })
        }
    }
    
    fileprivate func updateUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    @objc func showSlideOutMenu() {
        openMenu()
    }
    
    @objc func revealHomeBackgroundView() {
        homeView.revealBackgroundView()
    }
    
    @objc func hideHomeBackgroundView() {
        homeView.hideBackgroundView()
    }
    
    @objc func refreshAroundMeMap() {
        // Animate the button spin
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.aroundMeView.refreshButton.transform = self.aroundMeView.refreshButton.transform.rotated(by: .pi)
        })
        
        UIView.animate(withDuration: 0.25, delay: 0.15, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.aroundMeView.refreshButton.transform = self.aroundMeView.refreshButton.transform.rotated(by: .pi)
        })
        
        // Remove all annotations
        aroundMeView.mapView.removeAnnotations(aroundMeView.mapView.annotations)
        
        // Re-add the annotations
        addAroundMeMapAnnotations()
    }
    
    func addAroundMeMapAnnotations() {
        guard let currentUser = configuration.currentUser else { return }
        
        // Get users near the current user and add a new map annotation for them (this will include the current user)
        let usersReference = Database.database().reference(withPath: "users")
        usersReference.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    
                    var user: User!
                    if let cachedUser = configuration.userCache[childSnapshot.key] {
                        user = cachedUser
                    } else {
                        user = User(snapshot: childSnapshot)
                    }
                    
                    // Make sure the user is close enough to the current user to show
                    if let distance = currentUser.getDistanceFrom(user: user) {
                        if distance <= configuration.maximumUserDistance {
                            let userAnnotation = UserMapAnnotation(user: user)
                            self.aroundMeView.mapView.addAnnotation(userAnnotation)
                        }
                    }
                }
            }
        }
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
        addAroundMeMapAnnotations()
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
        
        return [
            Tab(view: exploreView, type: .attributedText(NSAttributedString(string: "EXPLORE", attributes: tabAttributes))),
            Tab(view: homeView, type: .attributedText(NSAttributedString(string: "HOME", attributes: tabAttributes))),
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
