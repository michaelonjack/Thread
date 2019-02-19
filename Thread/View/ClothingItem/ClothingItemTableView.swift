//
//  ClothingItemTableView.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemTableView: UITableView {
    
    weak var coordinator: ActiveUserCoordinator?
    
    var clothingItems: [ClothingItem] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 300
        register(ClothingItemTableViewCell.self, forCellReuseIdentifier: "ImageTableCell")
        
        delegate = self
        dataSource = self
    }
    
    func scrollToTop() {
        if clothingItems.count > 0 {
            scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}



extension ClothingItemTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ClothingItemTableViewCell else { return }
        
        if cell.blurDetailView.alpha == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                cell.blurDetailView.alpha = 1
                cell.detailStackView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                cell.blurDetailView.alpha = 0
                cell.detailStackView.alpha = 0
            })
        }
    }
}



extension ClothingItemTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell", for: indexPath)
        
        guard let clothingItemCell = cell as? ClothingItemTableViewCell else { return cell }
        
        let clothingItem = clothingItems[indexPath.row]
        
        clothingItemCell.delegate = self
        clothingItemCell.itemImageView.image = nil
        clothingItemCell.itemNameLabel.text = clothingItem.name
        clothingItemCell.blurDetailView.alpha = 0
        clothingItemCell.detailStackView.alpha = 0
        clothingItemCell.itemImageView.contentMode = .scaleAspectFit
        
        if let itemImage = clothingItem.smallItemImage {
            clothingItemCell.itemImageView.image = itemImage
        } else if let itemImageUrl = clothingItem.smallItemImageUrl {
            clothingItemCell.itemImageView.sd_setImage(with: itemImageUrl) { (image, error, _, _) in
                self.clothingItems[indexPath.row].smallItemImage = image
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
        
        return clothingItemCell
    }
}



extension ClothingItemTableView: ClothingItemTableCellDelegate {
    func viewClothingItem(at cell: ClothingItemTableViewCell) {
        guard let indexPath = self.indexPath(for: cell) else { return }
        
        let currentItem = clothingItems[indexPath.row]
        
        if let url = currentItem.itemUrl {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func selectClothingItem(at cell: ClothingItemTableViewCell) {
        guard let indexPath = self.indexPath(for: cell) else { return }
        
        let currentItem = clothingItems[indexPath.row]
        self.coordinator?.startEditingDetails(forClothingItem: currentItem)
    }
}
