//
//  UserProfileViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/2/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import SDWebImage

class UserProfileViewController: UIViewController {

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

        setupView()
        setUserInfo()
    }
    
    fileprivate func setupView() {
        
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
            
            if let imageUrlStr = user.profilePictureUrl {
                let imageUrl = URL(string: imageUrlStr)
                self.profilePictureButton.sd_setImage(with: imageUrl, for: .normal, completed: nil)
            }
            
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
}



extension UserProfileViewController: UICollectionViewDelegate {
    
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
        
        let cornerRadius:CGFloat = (collectionView.frame.height - 20) / 5.0
        feedCell.shadowView.backgroundColor = .white
        feedCell.shadowView.layer.cornerRadius = cornerRadius
        feedCell.shadowView.clipsToBounds = true
        
        feedCell.backgroundColor = .clear
        feedCell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        feedCell.layer.shadowOffset = CGSize(width: 8, height: 6)
        feedCell.layer.shadowOpacity = 0.1
        feedCell.layer.shadowPath = UIBezierPath(roundedRect: feedCell.bounds, cornerRadius: cornerRadius).cgPath
        
        if let clothingItemImageUrlStr = user?.clothingItems[indexPath.row].itemImageUrl {
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
