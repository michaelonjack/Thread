//
//  ExploreLocationDetailsView.swift
//  Thread
//
//  Created by Michael Onjack on 2/18/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ExploreLocationDetailsView: UIView {
    
    var pullIndicator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lighterGray
        v.clipsToBounds = true
        v.layer.cornerRadius = 4
        
        return v
    }()
    
    var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Medium", size: 30.0)
        
        return l
    }()
    
    var blurbLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 0
        l.font = UIFont(name: "AvenirNext-Regular", size: 15.0)
        
        return l
    }()
    
    var itemsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Medium", size: 25.0)
        l.text = "Items in this Area"
        l.alpha = 0
        
        return l
    }()
    
    var itemsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.isPagingEnabled = false
        cv.backgroundColor = .clear
        cv.alpha = 0
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        return cv
    }()
    
    var minimumYTranslation: CGFloat!
    var maximumYTranslation: CGFloat!
    
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
        
        layer.cornerRadius = frame.height / 20.0
        minimumYTranslation = frame.height - itemsCollectionView.frame.maxY
        maximumYTranslation = frame.height - (blurbLabel.frame.maxY + frame.height * 0.1)
    }
    
    fileprivate func setupView() {
        backgroundColor = .white
        clipsToBounds = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
        addSubview(pullIndicator)
        addSubview(nameLabel)
        addSubview(blurbLabel)
        addSubview(itemsLabel)
        addSubview(itemsCollectionView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            pullIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            pullIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            pullIndicator.heightAnchor.constraint(equalToConstant: 8),
            pullIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            
            nameLabel.topAnchor.constraint(equalTo: pullIndicator.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            blurbLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            blurbLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            blurbLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            blurbLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.18),
            
            itemsLabel.topAnchor.constraint(equalTo: blurbLabel.bottomAnchor, constant: 32),
            itemsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            itemsLabel.trailingAnchor.constraint(equalTo: blurbLabel.trailingAnchor),
            
            itemsCollectionView.topAnchor.constraint(equalTo: itemsLabel.bottomAnchor, constant: 16),
            itemsCollectionView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            itemsCollectionView.trailingAnchor.constraint(equalTo: blurbLabel.trailingAnchor),
            itemsCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.40)
        ])
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            break
        case .changed:
            if translation.y < 0 && frame.minY < minimumYTranslation {
                return
            }
            
            if translation.y > 0 && frame.minY > maximumYTranslation {
                return
            }
            
            transform = transform.translatedBy(x: 0, y: translation.y)
            
            let percentOpened = (maximumYTranslation - frame.minY) / (maximumYTranslation - minimumYTranslation)
            itemsLabel.alpha = percentOpened
            itemsCollectionView.alpha = percentOpened
        default:
            break
        }
        
        gesture.setTranslation(CGPoint.zero, in: self)
    }
}



extension ExploreLocationDetailsView: UICollectionViewDelegate {
    
}



extension ExploreLocationDetailsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        switch indexPath.row % 4 {
        case 0:
            cell.backgroundColor = .blue
        case 1:
            cell.backgroundColor = .red
        case 2:
            cell.backgroundColor = .yellow
        case 3:
            cell.backgroundColor = .green
        default:
            break
        }
        
        return cell
    }
}



extension ExploreLocationDetailsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 21) / 3, height: collectionView.frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
