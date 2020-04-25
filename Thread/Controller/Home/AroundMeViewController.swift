//
//  AroundMeViewController.swift
//  Thread
//
//  Created by Michael Onjack on 5/22/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import MapKit

class AroundMeViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?

    @IBOutlet weak var aroundMeView: AroundMeView!
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aroundMeView.mapView.delegate = self
        
        aroundMeView.refreshButton.addTarget(self, action: #selector(refreshMap), for: .touchUpInside)
    }

    @objc func refreshMap() {
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
                    
                    if let cachedUser = configuration.userCache.object(forKey: childSnapshot.key as NSString) {
                        user = cachedUser
                    } else {
                        user = User(snapshot: childSnapshot)
                    }
                    
                    if let distance = currentUser.getDistanceFrom(location: user.location), let _ = user.lastCheckIn {
                        
                        // Make sure the user is close enough to the current user to show
                        // and make sure the user isn't blocked or blocking this user
                        if distance <= configuration.maximumUserDistance
                            && !currentUser.blockedByUserIds.contains(user.uid)
                            && !currentUser.blockedUserIds.contains(user.uid) {
                            let userAnnotation = UserMapAnnotation(user: user)
                            self.aroundMeView.mapView.addAnnotation(userAnnotation)
                        }
                    }
                }
            }
        }
    }
}



extension AroundMeViewController: MKMapViewDelegate {
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



extension AroundMeViewController: UserMapAnnotationDelegate {
    func viewButtonPressed(userId: String) {
        coordinator?.viewUserProfile(userId: userId)
    }
}
