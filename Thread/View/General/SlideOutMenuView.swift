//
//  SlideOutMenuView.swift
//  Thread
//
//  Created by Michael Onjack on 2/15/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class SlideOutMenuView: UIView {
    
    var profilePictureView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .black
        l.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        
        return l
    }()
    
    var locationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .gray
        l.font = UIFont(name: "AvenirNext-Regular", size: 18.0)
        
        return l
    }()
    
    var statsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        
        return l
    }()
    
    var optionsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 300
        tv.register(SlideOutMenuTableViewCell.self, forCellReuseIdentifier: "SlideOutMenuCell")
        
        return tv
    }()
    
    var menuWidth: CGFloat!
    var isOpen: Bool = false
    
    init(ofWidth width: CGFloat) {
        super.init(frame: CGRect.zero)
        
        menuWidth = width
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.height / 2
        profilePictureView.clipsToBounds = true
    }
    
    fileprivate func setupView() {
        
        backgroundColor = .white
        
        if let currentUser = configuration.currentUser {
            setDetails(forUser: currentUser)
        } else {
            getCurrentUser { (currentUser) in
                self.setDetails(forUser: currentUser)
            }
        }
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        addSubview(profilePictureView)
        addSubview(nameLabel)
        addSubview(locationLabel)
        addSubview(statsLabel)
        addSubview(optionsTableView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            profilePictureView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            profilePictureView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            profilePictureView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            profilePictureView.widthAnchor.constraint(equalTo: profilePictureView.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profilePictureView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            statsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            statsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statsLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            optionsTableView.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 16),
            optionsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            optionsTableView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            optionsTableView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    fileprivate func setDetails(forUser user: User) {
        user.getLocationStr(completion: { (locationStr) in
            
            DispatchQueue.main.async {
                self.locationLabel.text = locationStr ?? "Unknown location"
            }
        })
        
        DispatchQueue.main.async {
            self.nameLabel.text = user.name
            self.statsLabel.attributedText = self.createStatsLabelString(favoritesCount: user.favoritedItems.count, followingCount: user.followingUserIds.count)
            
            if let profilePicture = user.profilePicture {
                self.profilePictureView.image = profilePicture
            } else if let picUrlStr = user.profilePictureUrl, let picUrl = URL(string: picUrlStr) {
                self.profilePictureView.sd_setImage(with: picUrl, completed: nil)
            }
        }
    }
    
    fileprivate func createStatsLabelString(favoritesCount: Int, followingCount: Int) -> NSAttributedString {
        let heavierAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 18)!
        ]
        
        let lighterAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14)!
        ]
        
        let mutableStr = NSMutableAttributedString()
        
        mutableStr.append( NSAttributedString(string: "\(favoritesCount) ", attributes: heavierAttributes) )
        mutableStr.append( NSAttributedString(string: "Favorites    ", attributes: lighterAttributes) )
        
        
        mutableStr.append( NSAttributedString(string: "\(followingCount) ", attributes: heavierAttributes) )
        mutableStr.append( NSAttributedString(string: "Following", attributes: lighterAttributes) )
        
        return mutableStr
    }
}



extension SlideOutMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
}



extension SlideOutMenuView: UITableViewDataSource {
    
    var cellLabels: [String] {
        return ["Profile", "Following", "Favorites", "Settings"]
    }
    
    var cellImages: [UIImage?] {
        return [
            UIImage(named: "AvatarMan"),
            UIImage(named: "Following"),
            UIImage(named: "Favorite"),
            UIImage(named: "Settings")
        ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideOutMenuCell", for: indexPath)
        
        guard let slideOutCell = cell as? SlideOutMenuTableViewCell else { return cell }
        
        slideOutCell.optionLabel.text = cellLabels[indexPath.section]
        slideOutCell.optionImageView.image = cellImages[indexPath.section]
        
        return slideOutCell
    }
}
