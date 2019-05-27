//
//  ClothingItemEditViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/8/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemEditViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var editView: ClothingItemEditView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var updateButtonActivityIndicator: UIActivityIndicatorView!
    
    var clothingItem: ClothingItem!
    var itemImageUpdated: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButton.setTitleColor(updateButton.backgroundColor, for: .disabled)
        
        editView.addTagButton.addTarget(self, action: #selector(addClothingItemTag), for: .touchUpInside)
        
        editView.tagsCollectionView.delegate = self
        editView.tagsCollectionView.dataSource = self
        
        itemImageView.clipsToBounds = true
        
        setInitialData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 6.0
        cancelButton.clipsToBounds = true
        
        updateButton.layer.cornerRadius = updateButton.frame.height / 6.0
        updateButton.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    fileprivate func setInitialData() {
        
        if let itemImage = clothingItem.itemImage {
            itemImageView.image = itemImage
        } else if let _ = clothingItem.itemImageUrl {
            clothingItem.getImage(ofPreferredSize: .normal) { (itemImage) in
                self.itemImageView.image = itemImage
            }
        }
        
        editView.nameField.textField.text = clothingItem.name
        editView.brandField.textField.text = clothingItem.brand
        editView.priceField.textField.text = clothingItem.price == nil ? "" : String(format: "%.2f", clothingItem.price!)
        editView.linkField.textField.text = clothingItem.itemUrl?.absoluteString
        editView.tags = clothingItem.tags
        editView.detailsField.text = clothingItem.details ?? ""
    }
    
    @IBAction func canceled(_ sender: Any) {
        coordinator?.cancelEditingClothingItem()
    }
    
    @IBAction func updateItem(_ sender: Any) {
        guard let currentUser = configuration.currentUser else { return }
        
        updateButtonActivityIndicator.startAnimating()
        updateButton.isEnabled = false
        
        // Require that a name be entered before updating the item
        if editView.nameField.textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            let errorNotification = NotificationView(type: .error, message: "Please enter an item name before updating.")
            errorNotification.show()
            updateButtonActivityIndicator.stopAnimating()
            updateButton.isEnabled = true
            return
        }
        
        // Require a valid number in the price field
        if let priceStr = editView.priceField.textField.text, !priceStr.isEmpty, Double(priceStr) == nil {
            let errorNotification = NotificationView(type: .error, message: "Please enter a valid number in the price field before updating.")
            errorNotification.show()
            updateButtonActivityIndicator.stopAnimating()
            updateButton.isEnabled = true
            return
        }
        
        // If the clothing item's image was updated, then we'll need to save the image to storage
        if itemImageUpdated {
            if let itemImage = clothingItem.itemImage {
                uploadImage(toLocation: "images/" + currentUser.uid + "/" + clothingItem.type.description, image: itemImage, completion: { (url, error) in
                    if error == nil {
                        self.clothingItem.itemImageUrl = url
                        if self.clothingItem.smallItemImageUrl == nil {
                            self.clothingItem.smallItemImageUrl = url
                        }
                        
                        self.updateItemDetails()
                        
                        self.coordinator?.finishEditingDetails(forClothingItem: self.clothingItem)
                    }
                })
            }
        }
        
        // If the clothing item image was NOT updated, then we can simply update the item's basic details and continue
        else {
            updateItemDetails()
            
            coordinator?.finishEditingDetails(forClothingItem: self.clothingItem)
        }
    }
    
    fileprivate func updateItemDetails() {
        clothingItem.details = editView.detailsField.text
        clothingItem.name = editView.nameField.textField.text ?? ""
        clothingItem.brand = editView.brandField.textField.text ?? ""
        clothingItem.price = Double(editView.priceField.textField.text ?? "")
        clothingItem.tags = editView.tags
        
        if let urlStr = editView.linkField.textField.text {
            clothingItem.itemUrl = URL(string: urlStr)
        }
    }
    
    @objc func addClothingItemTag() {
        var tagText = editView.tagsField.textField.text ?? ""
        tagText = tagText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard tagText != "" else { return }
        
        editView.tags.append( ClothingItemTag(name: tagText) )
        editView.tagsField.textField.text = ""
        editView.tagsCollectionView.reloadData()
        
        view.endEditing(true)
    }
}



extension ClothingItemEditViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tagText = editView.tags[indexPath.row].name
        
        let deleteConfirmationAlert = UIAlertController(title: "Delete Tag", message: "Are you sure you would like to delete the \"\(tagText)\" tag?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            self?.editView.tags.remove(at: indexPath.row)
            self?.editView.tagsCollectionView.reloadData()
        }
        deleteConfirmationAlert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteConfirmationAlert.addAction(cancelAction)
        
        self.present(deleteConfirmationAlert, animated: true)
    }
}



extension ClothingItemEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editView.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath)
        
        guard let tagCell = cell as? ClosetTagCollectionViewCell else { return cell }
        tagCell.backgroundColor = .black
        tagCell.label.text = editView.tags[indexPath.row].name
        tagCell.label.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        return tagCell
    }
}



extension ClothingItemEditViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagText = editView.tags[indexPath.row].name as NSString
        let textSize = tagText.size(withAttributes: [.font: UIFont(name: "AvenirNext-Medium", size: 16.0)!])
        
        return CGSize(width: textSize.width + 24, height: textSize.height + 4)
    }
}
