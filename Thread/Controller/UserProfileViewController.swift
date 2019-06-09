//
//  UserProfileViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/2/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import SDWebImage
import YPImagePicker

class UserProfileViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?
    
    @IBOutlet weak var userProfileView: UserProfileView!
    
    var userId: String!
    var user: User?
    
    var profilePictureUrls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //statusTextField.delegate = self
        
        userProfileView.picturesView.picturesCollectionView.delegate = self
        userProfileView.picturesView.picturesCollectionView.dataSource = self
        
        userProfileView.closetView.feedCollectionView.delegate = self
        userProfileView.closetView.feedCollectionView.dataSource = self
        
        userProfileView.scrollView.delegate = self
        
        setupView()
        setUserInfo()
    }
    
    fileprivate func setupView() {
        
        userProfileView.closetView.viewButton.addTarget(self, action: #selector(viewPressed), for: .touchUpInside)
        
        // If the current user is viewing their own profile, allow them to update their status
//        if userId == configuration.currentUser?.uid {
//            subtitleLabel.isHidden = true
//        } else {
//            statusTextField.isHidden = true
//        }
        
        setupFollowButton()
        setupBlockButton()
    }
    
    fileprivate func setupFollowButton() {
        userProfileView.followButton.selectAction = { [weak self] in
            guard let sself = self else { return }
            configuration.currentUser?.follow(userId: sself.userId)
        }
        
        userProfileView.followButton.deselectAction = { [weak self] in
            guard let sself = self else { return }
            configuration.currentUser?.unfollow(userId: sself.userId)
        }
    }
    
    fileprivate func setupBlockButton() {
        userProfileView.blockButton.selectAction = { [weak self] in
            guard let sself = self else { return }
            configuration.currentUser?.block(userId: sself.userId)
        }
        
        userProfileView.blockButton.deselectAction = { [weak self] in
            guard let sself = self else { return }
            configuration.currentUser?.unblock(userId: sself.userId)
        }
    }
    
    fileprivate func setUserInfo() {
        getUser(withId: userId) { (user) in
            self.user = user
            
            if user == configuration.currentUser {
                // Hide the Block and Follow buttons if the current user is viewing their own profile
                self.userProfileView.hideButtonsStackView()
            }
            
            // If the current user is already following this user, mark the Follow button as selected
            if configuration.currentUser?.followingUserIds.contains(user.uid) ?? false {
                self.userProfileView.followButton.select()
            }
            
            // IF the current user has already blocked this user, mark the Block button as selected
            if configuration.currentUser?.blockedUserIds.contains(user.uid) ?? false {
                self.userProfileView.blockButton.select()
            }
            
            self.profilePictureUrls = [user.profilePictureUrl, user.profilePictureUrl2, user.profilePictureUrl3].compactMap { $0 }
            
            // Adjust the picture indicator width using the number of pictures available
            if var indicatorWidthConstraint = self.userProfileView.picturesView.indicatorWidthConstraint {
                let numberOfPictures = CGFloat(self.profilePictureUrls.count)
                let indicatorView = self.userProfileView.picturesView.indicatorView
                let indicatorTrackView = self.userProfileView.picturesView.indicatorTrackView
                
                indicatorWidthConstraint.isActive = false
                indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalTo: indicatorTrackView.widthAnchor, multiplier: 1.0 / max(1.0, numberOfPictures))
                indicatorWidthConstraint.isActive = true
                self.userProfileView.picturesView.layoutIfNeeded()
            }
            
            self.userProfileView.statsView.favoritesCount = user.favoritedItems.count
            self.userProfileView.statsView.followingCount = user.followingUserIds.count
            self.userProfileView.statsView.followersCount = user.followerUserIds.count
            self.userProfileView.summaryView.lastCheckIn = user.lastCheckInStr
            self.userProfileView.summaryView.status = user.status ?? ""
            user.getLocationStr(completion: { (locationStr) in
                self.userProfileView.summaryView.location = locationStr ?? ""
            })
            
            DispatchQueue.main.async {
                self.userProfileView.summaryView.nameLabel.text = user.name
                self.userProfileView.picturesView.picturesCollectionView.reloadData()
                self.userProfileView.closetView.feedCollectionView.reloadData()
            }
        }
    }
    
    @objc func viewPressed() {
        viewCloset(initialIndex: 0)
    }
    
    func viewCloset(initialIndex: Int = 0) {
        if let user = user {
            coordinator?.viewCloset(forUser: user, initialIndex: initialIndex)
        } else {
            coordinator?.viewCloset(forUserId: userId, initialIndex: initialIndex)
        }
    }
    
    @IBAction func dismissProfile(_ sender: Any) {
        coordinator?.pop()
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  touchesBegan
    //
    //  Hides the keyboard when the user selects a non-textfield area
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}



extension UserProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let currentUser = configuration.currentUser else { return }
        guard currentUser.uid == userId else { return }
        guard let updatedStatus = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else { return }
        
        currentUser.status = updatedStatus
        updateDataForUser(userid: currentUser.uid, key: "status", value: updatedStatus as AnyObject)
    }
}



extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == userProfileView.closetView.feedCollectionView {
            viewCloset(initialIndex: indexPath.row)
        }
    }
}



extension UserProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == userProfileView.closetView.feedCollectionView {
            guard let user = user else { return 0 }
            
            return user.clothingItems.count
        }
        
        else if collectionView == userProfileView.picturesView.picturesCollectionView {
            return profilePictureUrls.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == userProfileView.closetView.feedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath)
            
            guard let feedCell = cell as? FeedCollectionViewCell else { return cell }
            feedCell.imageView.contentMode = .scaleAspectFit
            feedCell.imageView.image = nil
            feedCell.tag = indexPath.row
            
            if let clothingType = ClothingType(rawValue: indexPath.row), let clothingItem = user?.clothingItems[clothingType] {
                
                clothingItem.getImage(ofPreferredSize: .small) { (itemImage) in
                    // It's possible that a cell was reused before its original image fetch task completed causing the wrong image to be loaded into the cell. Utilize the tag to make sure we're updating the correct cell
                    // Scenario: Row 1 loads Cell A (fetches image 1)
                    //           Row 2 reuses Cell A (fetches image 2)
                    // Image 2 is fetched first and THEN image 1 is fetched causing it to overwrite image 2 (the correct image)
                    guard feedCell.tag == indexPath.row else { return }
                    feedCell.imageView.image = itemImage
                }
            }
            
            return feedCell
        }
        
        else if collectionView == userProfileView.picturesView.picturesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePictureCell", for: indexPath)
            
            guard let imageCell = cell as? ImageCollectionViewCell else { return cell }
            imageCell.imageView.contentMode = .scaleAspectFill
            imageCell.imageView.clipsToBounds = true
            imageCell.imageView.image = UIImage(named: "Avatar")
            imageCell.imageView.sd_setImage(with: profilePictureUrls[indexPath.row])
            
            return imageCell
        }
        
        fatalError("Collection view not accounter for: \(collectionView)")
    }
}



extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == userProfileView.closetView.feedCollectionView {
            let ratio: CGFloat = 1.7 / 2.0
            let height: CGFloat = collectionView.frame.height - 20
            let width: CGFloat = height * ratio
            
            return CGSize(width: width, height: height)
        }
        
        else if collectionView == userProfileView.picturesView.picturesCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
        fatalError("Collection view not accounter for: \(collectionView)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == userProfileView.closetView.feedCollectionView {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
        
        else if collectionView == userProfileView.picturesView.picturesCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        fatalError("Collection view not accounter for: \(collectionView)")
    }
}



extension UserProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == userProfileView.scrollView {
            guard scrollView.contentOffset.y < 0 else { return }
            
            let profilePicturesView = userProfileView.picturesView
            let contentOffsetY = scrollView.contentOffset.y
            
            // Determine how much the height of the pictures view will need to grow by
            let scaleFactor: CGFloat = (profilePicturesView.frame.height + (-contentOffsetY * 2)) / profilePicturesView.frame.height
            
            profilePicturesView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: contentOffsetY / scaleFactor).scaledBy(x: scaleFactor, y: scaleFactor)
        }
        
        else if scrollView == userProfileView.picturesView.picturesCollectionView {
            let contentOffsetX = scrollView.contentOffset.x
            let indicatorView = userProfileView.picturesView.indicatorView
            let indicatorOffsetX = (contentOffsetX / view.frame.width) * indicatorView.frame.width
            
            indicatorView.transform = CGAffineTransform(translationX: indicatorOffsetX, y: 0)
        }
    }
}
