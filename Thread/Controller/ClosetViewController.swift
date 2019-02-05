//
//  ClosetViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/3/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import SDWebImage

class ClosetViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?
    
    @IBOutlet weak var clothingItemsView: ClosetClothingItemsView!
    @IBOutlet weak var detailsView: ClosetDetailsView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var userId: String!
    var user: User?
    var revealDetailsAnimator: UIViewPropertyAnimator!
    var currentItemIndex: Int = 0 {
        didSet {
            guard let clothingType = ClothingType(rawValue: currentItemIndex) else { return }
            let currentItem = user?.clothingItems[clothingType]
            
            DispatchQueue.main.async {
                self.itemNameLabel.text = currentItem?.name
                self.favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clothingItemsView.clothingItemCollectionView.delegate = self
        clothingItemsView.clothingItemCollectionView.dataSource = self
        
        setUserData()
        setupAnimator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        revealDetailsAnimator.stopAnimation(true)
    }
    
    fileprivate func setUserData() {
        getUser(withId: userId) { (user) in
            self.user = user
            
            DispatchQueue.main.async {
                self.ownerLabel.text = user.name
                self.itemNameLabel.text = user.clothingItems[.top]?.name ?? "Top"
                self.clothingItemsView.clothingItemCollectionView.reloadData()
            }
        }
    }
    
    fileprivate func setupAnimator() {
        revealDetailsAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: { [weak self] in
            guard let sself = self else { return }
            
            sself.itemNameLabel.alpha = 0
            sself.detailsView.detailsView.alpha = 0
            sself.detailsView.reviewsView.alpha = 0
            sself.detailsView.otherView.alpha = 0
            sself.favoriteButton.alpha = 0.02
            
            sself.itemNameLabel.transform = sself.itemNameLabel.transform.translatedBy(x: 0, y: 30)
            sself.detailsView.detailsView.transform = sself.detailsView.detailsView.transform.translatedBy(x: 0, y: 30)
            sself.detailsView.reviewsView.transform = sself.detailsView.reviewsView.transform.translatedBy(x: 0, y: 30)
            sself.detailsView.otherView.transform = sself.detailsView.otherView.transform.translatedBy(x: 0, y: 30)
            sself.favoriteButton.transform = sself.favoriteButton.transform.translatedBy(x: 0, y: 30)
        })
        revealDetailsAnimator.pausesOnCompletion = true
    }
    
    @IBAction func itemFavorited(_ sender: Any) {
        favoriteButton.setImage(UIImage(named: "FavoriteClicked"), for: .normal)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.favoriteButton.transform = self.favoriteButton.transform.scaledBy(x: 2, y: 2)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.favoriteButton.transform = self.favoriteButton.transform.scaledBy(x: 0.5, y: 0.5)
            })
        }
    }
    
    @IBAction func dismissCloset(_ sender: Any) {
        coordinator?.pop()
    }
}



extension ClosetViewController: UICollectionViewDelegate {
    
}



extension ClosetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "closetItemCell", for: indexPath)
        
        guard let closetItemCell = cell as? ClosetItemCollectionViewCell else { return cell }
        
        var priceStr: String = "$0"
        var itemImageUrl: URL?
        
        if let type = ClothingType(rawValue: indexPath.row), let item = user?.clothingItems[type] {
            priceStr = "$" + String(item.price)
            itemImageUrl = URL(string: item.itemImageUrl)
        }
        
        closetItemCell.label.text = priceStr
        closetItemCell.imageView.sd_setImage(with: itemImageUrl, completed: nil)
        closetItemCell.imageView.contentMode = .scaleAspectFit
        
        return closetItemCell
    }
    
}



extension ClosetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}



extension ClosetViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = abs(scrollView.contentOffset.x)
        let currentPageOffsetX = contentOffsetX.truncatingRemainder(dividingBy: scrollView.frame.width)
        
        if currentPageOffsetX < scrollView.frame.width / 2 {
            revealDetailsAnimator.fractionComplete = currentPageOffsetX / (scrollView.frame.width / 2)
        } else {
            // Reverse the animation by counting down from 1 to 0
            revealDetailsAnimator.fractionComplete = 1 - ((currentPageOffsetX - (scrollView.frame.width / 2)) / (scrollView.frame.width / 2))
        }
        
        let currentIndex = Int(contentOffsetX / scrollView.frame.width) + Int(CGFloat(currentPageOffsetX / scrollView.frame.width).rounded())
        if currentItemIndex != currentIndex {
            currentItemIndex = currentIndex
        }
    }
}
