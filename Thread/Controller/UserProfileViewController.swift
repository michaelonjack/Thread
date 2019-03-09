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
    
    @IBOutlet weak var userStatisticsView: UserProfileStatsView!
    @IBOutlet weak var userSummaryView: UserProfileSummaryView!
    @IBOutlet weak var userFeedView: UserProfileFeedView!
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var profilePictureButtonShadowView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var followButton: CollapsibleButton!
    @IBOutlet weak var blockButton: CollapsibleButton!
    
    var userId: String!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userFeedView.feedCollectionView.delegate = self
        userFeedView.feedCollectionView.dataSource = self
        
        profilePictureButton.isUserInteractionEnabled = false

        setupView()
        setUserInfo()
    }
    
    fileprivate func setupView() {
        
        userFeedView.viewButton.addTarget(self, action: #selector(viewPressed), for: .touchUpInside)
        
        setupProfilePictureButton()
        setupFollowButton()
        setupBlockButton()
    }
    
    fileprivate func setupProfilePictureButton() {
        let cornerRadius = view.frame.height * 0.45 * 0.35 / 2
        
        profilePictureButton.layer.cornerRadius = cornerRadius
        profilePictureButton.layer.borderColor = UIColor.white.cgColor
        profilePictureButton.layer.borderWidth = 1.5
        profilePictureButton.clipsToBounds = true
        profilePictureButton.imageView?.contentMode = .scaleAspectFill
        
        profilePictureButtonShadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        profilePictureButtonShadowView.layer.shadowOffset = CGSize(width: 10, height: 8)
        profilePictureButtonShadowView.layer.shadowOpacity = 0.1
        profilePictureButtonShadowView.layer.shadowPath = UIBezierPath(roundedRect: profilePictureButton.bounds, cornerRadius: cornerRadius).cgPath
    }
    
    fileprivate func setupFollowButton() {
        followButton.deselectedTitle = "Follow"
        followButton.button.setTitle("Follow", for: .normal)
        followButton.selectedIcon = UIImage(named: "Check")!
        followButton.selectAction = {
            configuration.currentUser?.follow(userId: self.userId)
        }
        
        followButton.deselectAction = {
            configuration.currentUser?.unfollow(userId: self.userId)
        }
    }
    
    fileprivate func setupBlockButton() {
        blockButton.deselectedTitle = "Block"
        blockButton.button.setTitle("Block", for: .normal)
        blockButton.selectedIcon = UIImage(named: "Block")!
        blockButton.selectAction = {
            print("selected")
        }
        
        blockButton.deselectAction = {
            print("deselected")
        }
    }
    
    fileprivate func setUserInfo() {
        getUser(withId: userId) { (user) in
            self.user = user
            
            if user == configuration.currentUser {
                // Allow the user to update the profile picture if they're viewing their own profile
                self.profilePictureButton.isUserInteractionEnabled = true
                
                // Hide the Block and Follow buttons if the current user is viewing their own profile
                self.followButton.isHidden = true
                self.blockButton.isHidden = true
            }
            
            // If the current user is already following this user, mark the Follow button as selected
            if configuration.currentUser?.followingUserIds.contains(user.uid) ?? false {
                self.followButton.collapse()
            }
            
            // Update profile picture
            user.getProfilePicture(completion: { (profilePicture) in
                self.profilePictureButton.setImage(profilePicture, for: .normal)
            })
            
            self.userStatisticsView.favoritesCount = user.favoritedItems.count
            self.userStatisticsView.followingCount = user.followingUserIds.count
            self.userStatisticsView.followersCount = user.followerUserIds.count
            self.userSummaryView.status = user.status ?? ""
            self.userSummaryView.lastCheckIn = user.lastCheckInStr
            user.getLocationStr(completion: { (locationStr) in
                self.userSummaryView.location = locationStr ?? ""
            })
            
            DispatchQueue.main.async {
                self.nameLabel.text = user.name
                self.subtitleLabel.text = "Lebron is GOAT"
                self.userFeedView.feedCollectionView.reloadData()
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
    
    @IBAction func updateProfilePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) || UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var ypConfig = YPImagePickerConfiguration()
            ypConfig.onlySquareImagesFromCamera = true
            ypConfig.library.onlySquare = true
            ypConfig.showsFilters = true
            ypConfig.library.mediaType = .photo
            ypConfig.usesFrontCamera = false
            ypConfig.shouldSaveNewPicturesToAlbum = false
            
            let picker = YPImagePicker(configuration: ypConfig)
            picker.didFinishPicking { (items, _) in
                if let photo = items.singlePhoto, let currentUser = configuration.currentUser {
                    uploadImage(toLocation: "images/" + currentUser.uid + "/ProfilePicture", image: photo.image, completion: { (url, error) in
                        if error == nil {
                            currentUser.profilePicture = photo.image
                            currentUser.profilePictureUrl = url
                            self.profilePictureButton.setImage(photo.image, for: .normal)
                            currentUser.save()
                            
                            // Cache the profile picture
                            UserDefaults.standard.setValue(photo.image.jpegData(compressionQuality: 1), forKey: currentUser.uid + "-profilePicture")
                        }
                    })
                }
                
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissProfile(_ sender: Any) {
        coordinator?.pop()
    }
}



extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewCloset(initialIndex: indexPath.row)
    }
}



extension UserProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let user = user {
            return user.clothingItems.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath)
        
        guard let feedCell = cell as? FeedCollectionViewCell else { return cell }
        feedCell.imageView.contentMode = .scaleAspectFit
        feedCell.imageView.image = nil
        
        if let clothingType = ClothingType(rawValue: indexPath.row), let clothingItemImageUrl = user?.clothingItems[clothingType]?.itemImageUrl {
            let clothingItemImageUrl = clothingItemImageUrl
            feedCell.imageView.sd_setImage(with: clothingItemImageUrl, completed: nil)
        }
        
        return feedCell
    }
    
}



extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 1.7 / 2.0
        let height: CGFloat = collectionView.frame.height - 20
        let width: CGFloat = height * ratio
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
