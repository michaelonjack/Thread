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
        } else if let url = clothingItem.itemImageUrl {
            itemImageView.sd_setImage(with: url) { (image, error, _, _) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                self.clothingItem.itemImage = image
            }
        }
        
        editView.nameField.textField.text = clothingItem.name
        editView.brandField.textField.text = clothingItem.brand
        editView.priceField.textField.text = clothingItem.price == nil ? "" : String(format: "%.2f", clothingItem.price!)
        editView.linkField.textField.text = clothingItem.itemUrl?.absoluteString
        editView.tagsField.textField.text = clothingItem.tags.joined(separator: ",")
        editView.detailsField.text = clothingItem.details ?? ""
    }
    
    @IBAction func canceled(_ sender: Any) {
        coordinator?.cancelEditingClothingItem()
    }
    
    @IBAction func updateItem(_ sender: Any) {
        guard let currentUser = configuration.currentUser else { return }
        
        if let itemImage = clothingItem.itemImage {
            uploadImage(toLocation: "images/" + currentUser.uid + "/" + clothingItem.type.description, image: itemImage, completion: { (url, error) in
                if error == nil {
                    self.clothingItem.itemImageUrl = url
                    self.clothingItem.details = self.editView.detailsField.text
                    self.clothingItem.name = self.editView.nameField.textField.text ?? ""
                    self.clothingItem.brand = self.editView.brandField.textField.text ?? ""
                    self.clothingItem.price = Double(self.editView.priceField.textField.text ?? "")
                    self.clothingItem.tags = self.editView.tagsField.textField.text?.components(separatedBy: ",") ?? []
                    
                    if let urlStr = self.editView.linkField.textField.text {
                        self.clothingItem.itemUrl = URL(string: urlStr)
                    }
                    
                    if self.clothingItem.smallItemImageUrl == nil {
                        self.clothingItem.smallItemImageUrl = url
                    }
                    
                    self.coordinator?.finishEditingDetails(forClothingItem: self.clothingItem)
                }
            })
        }
    }
}
