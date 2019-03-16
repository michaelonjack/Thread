//
//  UserTableViewCell.swift
//  Thread
//
//  Created by Michael Onjack on 2/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var userPictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
        
        return label
    }()
    
    var userStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .gray
        label.font = UIFont(name: "AvenirNext-Regular", size: 15.0)
        
        return label
    }()
    
    var followButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Follow"), for: .normal)
        
        return button
    }()
    
    var userClothingItemsView: UserProfileFeedView = {
        let feedView = UserProfileFeedView()
        feedView.translatesAutoresizingMaskIntoConstraints = false
        feedView.viewButton.isHidden = true
        
        return feedView
    }()
    
    var itemImages: [UIImage?] = [nil, nil, nil, nil]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userPictureImageView.layer.cornerRadius = userPictureImageView.frame.height / 2
    }
    
    fileprivate func setupView() {
        
        selectionStyle = .none
        
        userClothingItemsView.feedCollectionView.delegate = self
        userClothingItemsView.feedCollectionView.dataSource = self
        
        addSubview(userPictureImageView)
        addSubview(userNameLabel)
        addSubview(userStatusLabel)
        addSubview(followButton)
        addSubview(userClothingItemsView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            userPictureImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            userPictureImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            userPictureImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            userPictureImageView.widthAnchor.constraint(equalTo: userPictureImageView.heightAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: userPictureImageView.topAnchor),
            userNameLabel.heightAnchor.constraint(equalTo: userPictureImageView.heightAnchor, multiplier: 0.5),
            userNameLabel.leadingAnchor.constraint(equalTo: userPictureImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -8),
            
            userStatusLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            userStatusLabel.bottomAnchor.constraint(equalTo: userPictureImageView.bottomAnchor),
            userStatusLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userStatusLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            
            followButton.centerYAnchor.constraint(equalTo: userPictureImageView.centerYAnchor),
            followButton.heightAnchor.constraint(equalTo: userPictureImageView.heightAnchor, multiplier: 0.5),
            followButton.widthAnchor.constraint(equalTo: followButton.heightAnchor),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            userClothingItemsView.leadingAnchor.constraint(equalTo: userPictureImageView.leadingAnchor),
            userClothingItemsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userClothingItemsView.topAnchor.constraint(equalTo: userPictureImageView.bottomAnchor, constant: 16),
            userClothingItemsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}



extension UserTableViewCell: UICollectionViewDelegate {
    
}



extension UserTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath)
        
        guard let feedCell = cell as? FeedCollectionViewCell else { return cell }
        feedCell.imageView.image = nil
        feedCell.imageView.contentMode = .scaleAspectFit
        
        feedCell.imageView.image = itemImages[indexPath.row]
        
        return feedCell
    }
}



extension UserTableViewCell: UICollectionViewDelegateFlowLayout {
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
