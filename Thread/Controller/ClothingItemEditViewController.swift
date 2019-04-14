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
    
    var clothingItem: ClothingItem!
    var itemImageUpdated: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        editView.tagsField.textField.text = clothingItem.tags.map { $0.name }.joined(separator: ",")
        editView.detailsField.text = clothingItem.details ?? ""
    }
    
    @IBAction func canceled(_ sender: Any) {
        coordinator?.cancelEditingClothingItem()
    }
    
    @IBAction func updateItem(_ sender: Any) {
        guard let currentUser = configuration.currentUser else { return }
        
        // Require that a name be entered before updating the item
        if editView.nameField.textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            let errorNotification = NotificationView(type: .error, message: "Please enter an item name before updating.")
            errorNotification.show()
            return
        }
        
        // Require a valid number in the price field
        if let priceStr = editView.priceField.textField.text, !priceStr.isEmpty, Double(priceStr) == nil {
            let errorNotification = NotificationView(type: .error, message: "Please enter a valid number in the price field before updating.")
            errorNotification.show()
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
        clothingItem.tags = getClothingItemTags()
        
        if let urlStr = editView.linkField.textField.text {
            clothingItem.itemUrl = URL(string: urlStr)
        }
    }
    
    fileprivate func getClothingItemTags() -> [ClothingItemTag] {
        var tagNames:[String] = editView.tagsField.textField.text?.components(separatedBy: ",") ?? []
        tagNames = tagNames.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        return tagNames.map { ClothingItemTag(name: $0) }
    }
}
