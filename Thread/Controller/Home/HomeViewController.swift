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
    @IBOutlet var homeView: HomeView!
    
    var aroundMeController: AroundMeViewController!
    var exploreController: ExploreViewController!
    
    var followingUserIds: [String] = []
    var followedItems: [(User, ClothingItem)] = []
    var isCheckingIn = false
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aroundMeController = AroundMeViewController.instantiate()
        aroundMeController.coordinator = coordinator
        
        exploreController = ExploreViewController.instantiate()
        exploreController.coordinator = coordinator
        
        updateUserLocation()
        
        setupTabbedPageView()
        setupHomeView()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        // Update the child controllers to inherit the parent's safe area
        aroundMeController.additionalSafeAreaInsets = view.safeAreaInsets
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
        for annotation in aroundMeController.aroundMeView.mapView.annotations {
            if let userAnnotation = annotation as? UserMapAnnotation, userAnnotation.user == currentUser {
                aroundMeController.aroundMeView.mapView.removeAnnotation(annotation)
            }
        }
        
        let notification = NotificationView(type: .info, message: "Location successfully hidden! You'll no longer appear on the map.")
        notification.show()
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
        aroundMeController.aroundMeView.mapView.setRegion(mapRegion, animated: true)
        aroundMeController.addAroundMeMapAnnotations()
        
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
