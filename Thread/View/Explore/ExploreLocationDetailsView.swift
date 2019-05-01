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
    
    var weatherView: ExploreLocationWeatherView = {
        let wv = ExploreLocationWeatherView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        
        return wv
    }()
    
    var itemsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont(name: "AvenirNext-Medium", size: 25.0)
        l.text = "Items in this area"
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
    
    var nearbyItems: [(User, ClothingItem)] = []
    
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
        maximumYTranslation = frame.height - (weatherView.frame.maxY + frame.height * 0.05)
    }
    
    fileprivate func setupView() {
        backgroundColor = .white
        clipsToBounds = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
        addSubview(pullIndicator)
        addSubview(nameLabel)
        addSubview(weatherView)
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
            
            weatherView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            weatherView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            weatherView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.28),
            
            itemsLabel.topAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: 16),
            itemsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            itemsLabel.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor),
            
            itemsCollectionView.topAnchor.constraint(equalTo: itemsLabel.bottomAnchor, constant: 16),
            itemsCollectionView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            itemsCollectionView.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor),
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = nearbyItems[indexPath.row].1
        
        if let itemUrl = selectedItem.itemUrl {
            if UIApplication.shared.canOpenURL(itemUrl) {
                UIApplication.shared.open(itemUrl, options: [:])
            }
        }
    }
}



extension ExploreLocationDetailsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        guard let imageCell = cell as? ImageCollectionViewCell else { return cell }
        
        imageCell.imageView.contentMode = .scaleAspectFit
        imageCell.imageView.image = nil
        
        if indexPath.row < nearbyItems.count {
            let item = nearbyItems[indexPath.row]
            item.1.getImage(ofPreferredSize: .small) { (itemImage) in
                imageCell.backgroundColor = .white
                imageCell.imageView.image = itemImage
            }
        }
        
        else {
            switch indexPath.row % 4 {
            case 0:
                cell.backgroundColor = .ultraLightBlue
            case 1:
                cell.backgroundColor = .ultraLightRed
            case 2:
                cell.backgroundColor = .cream
            case 3:
                cell.backgroundColor = .ultraLightGreen
            default:
                break
            }
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
