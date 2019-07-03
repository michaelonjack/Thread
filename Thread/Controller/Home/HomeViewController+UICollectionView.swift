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
        if collectionView == homeView.followingView.usersHeaderView.followingUsersCollectionView {
            guard let currentUser = configuration.currentUser else { return }
            
            let selectedUserId = currentUser.followingUserIds[indexPath.row]
            coordinator?.viewUserProfile(userId: selectedUserId)
        }
    }
}



extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homeView.followingView.usersHeaderView.followingUsersCollectionView {
            return followingUserIds.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == homeView.followingView.usersHeaderView.followingUsersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFollowingUserCell", for: indexPath)
            
            guard let imageCell = cell as? RoundedImageCollectionViewCell else { return cell }
            
            imageCell.imageView.contentMode = .scaleAspectFill
            imageCell.imageView.image = UIImage(named: "Avatar")
            imageCell.tag = indexPath.row
            
            let userId = followingUserIds[indexPath.row]
            getUser(withId: userId) { (user) in
                user.getProfilePicture(completion: { (profilePicture) in
                    guard imageCell.tag == indexPath.row else { return }
                    imageCell.imageView.image = profilePicture
                })
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
        if collectionView == homeView.followingView.usersHeaderView.followingUsersCollectionView {
            return CGSize(width: collectionView.frame.height * 0.85, height: collectionView.frame.height * 0.85)
        }
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == homeView.followingView.usersHeaderView.followingUsersCollectionView {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
