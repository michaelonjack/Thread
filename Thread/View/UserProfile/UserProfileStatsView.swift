//
//  UserProfileStatsView.swift
//  Thread
//
//  Created by Michael Onjack on 2/2/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class UserProfileStatsView: UIView {
    
    var followersCount: Int = 125
    var favoritesCount: Int = 112 {
        didSet {
            DispatchQueue.main.async {
                self.favoritesLabel.attributedText = self.createStatsLabel(title: String(self.favoritesCount), subtitle: "Favorites")
            }
        }
    }
    var followingCount: Int = 453
    
    var allLabelsStackView: UIStackView!
    
    var followersLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        
        return label
    }()
    
    var favoritesLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        
        return label
    }()
    
    var followingLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        
        return label
    }()
    
    var divider: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        followersLabel.attributedText = createStatsLabel(title: String(followersCount), subtitle: "Followers")
        favoritesLabel.attributedText = createStatsLabel(title: String(favoritesCount), subtitle: "Favorites")
        followingLabel.attributedText = createStatsLabel(title: String(followingCount), subtitle: "Following")
        
        allLabelsStackView = UIStackView(arrangedSubviews: [followersLabel, favoritesLabel, followingLabel])
        allLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        allLabelsStackView.axis = .horizontal
        allLabelsStackView.distribution = .fillEqually
        
        addSubview(allLabelsStackView)
        addSubview(divider)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            allLabelsStackView.topAnchor.constraint(equalTo: topAnchor),
            allLabelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            allLabelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            allLabelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    fileprivate func createStatsLabel(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 18)!
        ]
        
        let subtitleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 13)!
        ]
        
        let mutableStr = NSMutableAttributedString()
        mutableStr.append( NSAttributedString(string: title + "\n", attributes: titleAttributes) )
        mutableStr.append( NSAttributedString(string: subtitle, attributes: subtitleAttributes) )
        
        return mutableStr
    }
}
