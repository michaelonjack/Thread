//
//  ClothingItemTableView.swift
//  Thread
//
//  Created by Michael Onjack on 2/9/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemTableView: UIView {
    
    var itemsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 300
        tv.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableCell")
        
        return tv
    }()
    
    var clothingItems: [ClothingItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        addSubview(itemsTableView)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            itemsTableView.topAnchor.constraint(equalTo: topAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            itemsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}



extension ClothingItemTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



extension ClothingItemTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell", for: indexPath)
        let clothingItem = clothingItems[indexPath.row]
        
        guard let imageCell = cell as? ImageTableViewCell else { return cell }
        
        imageCell.itemImageView.image = nil
        imageCell.itemImageView.contentMode = .scaleAspectFit
        
        if let itemImage = clothingItem.itemImage {
            imageCell.itemImageView.image = itemImage
        } else if let itemImageUrlStr = clothingItem.itemImageUrl, let itemImageUrl = URL(string: itemImageUrlStr) {
            imageCell.itemImageView.sd_setImage(with: itemImageUrl) { (image, error, _, _) in
                self.clothingItems[indexPath.row].itemImage = image
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
        
        return imageCell
    }
    
    
}
