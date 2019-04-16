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
    
    var followingUserIds: [String] = []
    var followedItems: [(User, ClothingItem)] = []
    var isCheckingIn = false
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aroundMeView.mapView.delegate = self
        
        updateUserLocation()
        
        setupTabbedPageView()
        setupExploreView()
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
    
    fileprivate func setupExploreView() {
        
    }
    
    fileprivate func setupAroundMeView() {
        aroundMeView.refreshButton.addTarget(self, action: #selector(refreshAroundMeMap), for: .touchUpInside)
    }
    
    fileprivate func setupHomeView() {
        homeView.showMenuButton.addTarget(self, action: #selector(showSlideOutMenu), for: .touchUpInside)
        homeView.profileButton.addTarget(self, action: #selector(viewCurrentUserProfile), for: .touchUpInside)
        homeView.checkInButton.addTarget(self, action: #selector(checkInUser), for: .touchUpInside)
        homeView.hideLocationButton.addTarget(self, action: #selector(hideUserLocation), for: .touchUpInside)
        
        // Set up the collection views for the followed users view
        homeView.followingUsersView.followingUsersCollectionView.delegate = self
        homeView.followingUsersView.followingUsersCollectionView.dataSource = self
        
        // Set up the table view for the followed items
        homeView.followingItemsView.followingItemsTableView.delegate = self
        homeView.followingItemsView.followingItemsTableView.dataSource = self
        
        // Set the user-specific information
        getCurrentUser { (currentUser) in
            
            // Reload the following users table view
            self.followingUserIds = currentUser.followingUserIds
            self.homeView.followingUsersView.followingUsersCollectionView.reloadData()
            
            // Reload the following items collection view
            currentUser.getFollowedItems(completion: { (followedItems) in
                // Only use items with images in the table view
                var followedItemsWithImages = followedItems.filter { $0.1.itemImageUrl != nil }
                // Randomize the results
                followedItemsWithImages.shuffle()
                
                self.followedItems = followedItemsWithImages
                self.homeView.followingItemsView.followingItemsTableView.reloadData()
                
            })
            
            self.homeView.nameLabel.text = currentUser.name
            currentUser.getLocationStr(completion: { (locationStr) in
                self.homeView.locationLabel.text = locationStr
            })
            
            currentUser.getProfilePicture(completion: { (profilePicture) in
                self.homeView.profileButton.setImage(profilePicture, for: .normal)
                
                // Cache the profile picture if it has not already been saved
                if let profilePicture = profilePicture, UserDefaults.standard.data(forKey: currentUser.uid + "-profilePicture") == nil {
                    UserDefaults.standard.setValue(profilePicture.jpegData(compressionQuality: 1), forKey: currentUser.uid + "-profilePicture")
                }
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
    
    @objc func viewCurrentUserProfile() {
        guard let currentUser = configuration.currentUser else { return }
        
        coordinator?.viewUserProfile(userId: currentUser.uid)
    }
    
    @objc func checkInUser() {
        guard let currentUser = configuration.currentUser else { return }
        currentUser.lastCheckIn = Date()
        
        DispatchQueue.main.async {
            self.isCheckingIn = true
            
            let notification = NotificationView(type: .info, message: "Checking in...")
            notification.show()
        }
        
        updateUserLocation()
    }
    
    @objc func hideUserLocation() {
        guard let currentUser = configuration.currentUser else { return }
        currentUser.lastCheckIn = nil
        currentUser.location = nil
        currentUser.save()
        
        // Remove the current user's annotation from the map
        for annotation in aroundMeView.mapView.annotations {
            if let userAnnotation = annotation as? UserMapAnnotation, userAnnotation.user == currentUser {
                aroundMeView.mapView.removeAnnotation(annotation)
            }
        }
        
        let notification = NotificationView(type: .info, message: "Location successfully hidden! You'll no longer appear on the map.")
        notification.show()
    }
    
    @objc func refreshAroundMeMap() {
        // Animate the button spin
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.aroundMeView.refreshButton.transform = self.aroundMeView.refreshButton.transform.rotated(by: .pi)
        })
        
        UIView.animate(withDuration: 0.25, delay: 0.15, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.aroundMeView.refreshButton.transform = self.aroundMeView.refreshButton.transform.rotated(by: .pi)
        })
        
        // Re-add the annotations
        addAroundMeMapAnnotations()
    }
    
    func addAroundMeMapAnnotations() {
        guard let currentUser = configuration.currentUser else { return }
        
        // Remove all current annotations if any exist
        aroundMeView.mapView.removeAnnotations(aroundMeView.mapView.annotations)
        
        // Get users near the current user and add a new map annotation for them (this will include the current user)
        let usersReference = Database.database().reference(withPath: "users")
        usersReference.keepSynced(true)
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
                    if let distance = currentUser.getDistanceFrom(user: user), let _ = user.lastCheckIn {
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
        
        if isCheckingIn {
            DispatchQueue.main.async {
                self.isCheckingIn = false
                
                let notification = NotificationView(type: .success, message: "Check in successful! You will now be visible to other users on the map.")
                notification.show()
            }
        }
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




