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
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
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
    
    fileprivate func setUserInfo() {
        getUser(withId: userId) { (user) in
            self.user = user
            
            // Allow the user to update the profile picture if they're viewing their own profile
            if user == configuration.currentUser {
                self.profilePictureButton.isUserInteractionEnabled = true
            }
            
            user.getProfilePicture(completion: { (profilePicture) in
                self.profilePictureButton.setImage(profilePicture, for: .normal)
            })
            
            self.userStatisticsView.favoritesCount = user.favoritedItems.count
            self.userStatisticsView.followingCount = user.followingUserIds.count
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
                            currentUser.profilePictureUrl = url?.absoluteString
                            self.profilePictureButton.setImage(photo.image, for: .normal)
                            currentUser.save()
                        }
                    })
                }
                
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
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
        
        if let clothingType = ClothingType(rawValue: indexPath.row), let clothingItemImageUrlStr = user?.clothingItems[clothingType]?.itemImageUrl {
            let clothingItemImageUrl = URL(string: clothingItemImageUrlStr)
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
