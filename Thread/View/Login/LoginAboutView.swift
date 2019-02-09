//
//  LoginAboutView.swift
//  Thread
//
//  Created by Michael Onjack on 2/7/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class LoginAboutView: UIView {
    
    var circleView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1
        v.backgroundColor = .clear
        
        return v
    }()
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        cv.register(LoginAboutCollectionViewCell.self, forCellWithReuseIdentifier: "LoginAboutCell")
        
        return cv
    }()
    
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
        
        circleView.layer.cornerRadius = circleView.frame.height / 2.0
        circleView.clipsToBounds = true
    }
    
    fileprivate func setupView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(circleView)
        addSubview(collectionView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor),
            collectionView.widthAnchor.constraint(equalTo: widthAnchor),
            
            circleView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            circleView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            circleView.heightAnchor.constraint(equalTo: collectionView.heightAnchor, multiplier: 0.8),
            circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor)
        ])
    }
}



extension LoginAboutView: UICollectionViewDelegate {
    
}



extension LoginAboutView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoginAboutCell", for: indexPath)
        
        guard let aboutCell = cell as? LoginAboutCollectionViewCell else { return cell }
        
        switch indexPath.row {
        case 0:
            aboutCell.imageView.image = UIImage(named: "AppIconAlt")
            aboutCell.label.text = "Share what you wear with those around you."
        case 1:
            aboutCell.imageView.image = UIImage(named: "globe")
            aboutCell.label.text = "Find growing trends around the world."
        case 2:
            let heartImage = UIImage(named: "FavoriteClicked")?.withRenderingMode(.alwaysTemplate)
            aboutCell.imageView.image = heartImage
            aboutCell.imageView.tintColor = .white
            aboutCell.label.text = "Follow your favorite items and people to keep track of the styles you like."
        default:
            break
        }
        
        return aboutCell
    }
}



extension LoginAboutView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
