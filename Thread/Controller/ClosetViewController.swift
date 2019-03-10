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
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var userId: String!
    var user: User?
    var revealDetailsAnimator: UIViewPropertyAnimator!
    var currentItemIndex: Int! {
        didSet {
            updateViewForNewItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clothingItemsView.clothingItemCollectionView.delegate = self
        clothingItemsView.clothingItemCollectionView.dataSource = self
        
        if let user = user {
            setUserData()
            
            // If the owner of the item is not the current user, remove the ability to update
            if configuration.currentUser != user {
                buttonsStackView.removeArrangedSubview(updateButton)
            }
        } else {
            getUser(withId: userId) { (user) in
                self.user = user
                self.setUserData()
                
                // If the owner of the item is not the current user, remove the ability to update
                if configuration.currentUser != user {
                    self.buttonsStackView.removeArrangedSubview(self.updateButton)
                }
            }
        }
        
        setUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        revealDetailsAnimator.stopAnimation(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        revealDetailsAnimator = nil
        setupAnimator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = updateButton.frame.height / 5.0
        
        viewButton.clipsToBounds = true
        viewButton.layer.cornerRadius = viewButton.frame.height / 5.0
    }
    
    fileprivate func setUserData() {
        guard let user = user else { return }
        guard let clothingType = ClothingType(rawValue: self.currentItemIndex) else { return }
        let currentItem = user.clothingItems[clothingType]
        
        DispatchQueue.main.async {
            self.ownerLabel.text = user.name
            self.itemNameLabel.text = currentItem?.name ?? clothingType.description
            self.detailsView.detailsView.detailsTextView.text = currentItem?.details
            
            self.clothingItemsView.clothingItemCollectionView.reloadData()
            self.clothingItemsView.clothingItemCollectionView.scrollToItem(at: IndexPath(row: self.currentItemIndex, section: 0), at: .centeredHorizontally, animated: false)
            
            if let currentUser = configuration.currentUser, let currentItem = currentItem {
                if currentUser.favoritedItems.contains(currentItem) {
                    self.favoriteButton.setImage(UIImage(named: "FavoriteClicked"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
                }
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
    
    func updateViewForNewItem() {
        if !isViewLoaded { return }
        guard let clothingType = ClothingType(rawValue: currentItemIndex) else { return }
        let currentItem = user?.clothingItems[clothingType]
        
        DispatchQueue.main.async {
            self.itemNameLabel.text = currentItem?.name ?? clothingType.description
            self.detailsView.detailsView.detailsTextView.text = currentItem?.details
            
            if let currentUser = configuration.currentUser, let currentItem = currentItem {
                if currentUser.favoritedItems.contains(currentItem) {
                    self.favoriteButton.setImage(UIImage(named: "FavoriteClicked"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func itemFavorited(_ sender: Any) {
        guard let currentClothingType = ClothingType(rawValue: currentItemIndex) else { return }
        guard let currentItem = user?.clothingItems[currentClothingType] else { return }
        guard let currentUser = configuration.currentUser else { return }
        
        // User currently has the item in their favorites so they're un-favoriting the item
        if currentUser.favoritedItems.contains(currentItem) {
            currentUser.favoritedItems.removeAll(where: { $0 == currentItem })
            
            favoriteButton.setImage(UIImage(named: "Favorite"), for: .normal)
        }
        
        // User is requesting to add the item to their favorites
        else {
            currentUser.favoritedItems.append(currentItem)
            
            favoriteButton.setImage(UIImage(named: "FavoriteClicked"), for: .normal)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.favoriteButton.transform = self.favoriteButton.transform.scaledBy(x: 2, y: 2)
            }) { (_) in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.favoriteButton.transform = self.favoriteButton.transform.scaledBy(x: 0.5, y: 0.5)
                })
            }
        }
    }
    
    @IBAction func viewItem(_ sender: UIButton) {
        guard let currentClothingType = ClothingType(rawValue: currentItemIndex) else { return }
        guard let currentItem = user?.clothingItems[currentClothingType] else { return }
        
        if let url = currentItem.itemUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        } else {
            DispatchQueue.main.async {
                sender.setTitle("Link Not Provided", for: .normal)
                sender.backgroundColor = .red
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                sender.setTitle("View", for: .normal)
                sender.backgroundColor = .black
            }
        }
    }
    
    @IBAction func updateClothingItem(_ sender: Any) {
        guard let currentType = ClothingType(rawValue: currentItemIndex) else { return }
        let currentItem = user?.clothingItems[currentType]
        
        coordinator?.updateClothingItem(ofType: currentType, existingItem: currentItem)
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
        guard let clothingType = ClothingType(rawValue: indexPath.row) else { return cell }
        
        // Set default values
        closetItemCell.imageView.image = UIImage(named: clothingType.description)
        closetItemCell.label.text = "No Price"
        closetItemCell.imageView.contentMode = .scaleAspectFit
        
        if let item = user?.clothingItems[clothingType] {
            
            if let price = item.price {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                let priceStr = formatter.string(from: price as NSNumber) ?? "No Price"
                
                closetItemCell.label.text = priceStr
            }
            
            closetItemCell.imageView.sd_setImage(with: item.itemImageUrl, completed: nil)
        }
        
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
        
        // Reset the animator once the transition completes so the animated views can be interacted with (.isUserInteractionEnabled doesn't work -_-)
        if revealDetailsAnimator.fractionComplete == 0 {
            revealDetailsAnimator.stopAnimation(true)
            revealDetailsAnimator.finishAnimation(at: .start)
            setupAnimator()
        }
    }
}
