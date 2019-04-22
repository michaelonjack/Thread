//
//  HomeViewController+UICollectionView.swift
//  Thread
//
//  Created by Michael Onjack on 3/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == homeView.followingUsersView.followingUsersCollectionView {
            guard let currentUser = configuration.currentUser else { return }
            
            let selectedUserId = currentUser.followingUserIds[indexPath.row]
            coordinator?.viewUserProfile(userId: selectedUserId)
        }
        
            
            
        else if collectionView == exploreView.locationsCollectionView {
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ExploreLocationCollectionViewCell else { return }
            guard let rootView = selectedCell.window?.subviews[0] else { return }
            
            
            let originInParent = selectedCell.convert(CGPoint(x: 0, y: 0), to: rootView)
            let frameInRootView = CGRect(x: originInParent.x, y: originInParent.y, width: selectedCell.frame.width, height: selectedCell.frame.height)
            
            let location = configuration.places[indexPath.row]
            let locationExpandedView = ExploreLocationExpandedView(frame: frameInRootView)
            locationExpandedView.translatesAutoresizingMaskIntoConstraints = false
            locationExpandedView.detailsView.nearbyItems = location.nearbyItems
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
}



extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homeView.followingUsersView.followingUsersCollectionView {
            return followingUserIds.count
        }
        
            
            
        else if collectionView == exploreView.locationsCollectionView {
            return configuration.places.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == homeView.followingUsersView.followingUsersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFollowingUserCell", for: indexPath)
            
            guard let imageCell = cell as? RoundedImageCollectionViewCell else { return cell }
            
            imageCell.imageView.contentMode = .scaleAspectFill
            imageCell.imageView.image = UIImage(named: "Avatar")
            
            let userId = followingUserIds[indexPath.row]
            getUser(withId: userId) { (user) in
                user.getProfilePicture(completion: { (profilePicture) in
                    imageCell.imageView.image = profilePicture
                })
            }
            
            return imageCell
        }
            
            
            
        else if collectionView == exploreView.locationsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath)
            
            guard let imageCell = cell as? ExploreLocationCollectionViewCell else { return cell }
            
            let location = configuration.places[indexPath.row]
            imageCell.imageView.contentMode = .scaleAspectFill
            
            location.getImage { (image) in
                DispatchQueue.main.async {
                    imageCell.imageView.image = image
                }
            }
            
            return imageCell
        }
            
        else {
            fatalError("collecton view not accounted for: \(collectionView)")
        }
    }
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == homeView.followingUsersView.followingUsersCollectionView {
            return CGSize(width: collectionView.frame.height * 0.85, height: collectionView.frame.height * 0.85)
        }
        
        else if collectionView == exploreView.locationsCollectionView {
            return CGSize(width: collectionView.frame.width * 0.95, height: collectionView.frame.height * 0.4)
        }
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == homeView.followingUsersView.followingUsersCollectionView {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        
        else if collectionView == exploreView.locationsCollectionView {
            return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
