//
//  ClosetUpdateOptionsViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/8/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import YPImagePicker

class ClosetUpdateOptionsViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var editView: UIView!
    
    var clothingItem: ClothingItem?
    var clothingType: ClothingType!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        let buttonViews: [UIView] = [searchView, cameraView, editView]
        
        buttonViews.forEach { (view) in
            view.layer.cornerRadius = view.frame.height / 6.0
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 3
            view.clipsToBounds = true
        }
    }

    @IBAction func chooseEditOption(_ sender: Any) {
        guard let item = clothingItem else { return }
        self.dismiss(animated: true, completion: nil)
        coordinator?.startEditingDetails(forClothingItem: item)
    }
    
    @IBAction func chooseSearchOption(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        coordinator?.searchClothingItems(forType: clothingType)
    }
    
    @IBAction func chooseCameraOption(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) || UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var ypConfig = YPImagePickerConfiguration()
            ypConfig.onlySquareImagesFromCamera = false
            ypConfig.library.onlySquare = false
            ypConfig.showsFilters = true
            ypConfig.library.mediaType = .photo
            ypConfig.usesFrontCamera = false
            ypConfig.shouldSaveNewPicturesToAlbum = false
            
            let picker = YPImagePicker(configuration: ypConfig)
            picker.didFinishPicking { (items, _) in
                if let photo = items.singlePhoto {
                    let newItem = ClothingItem(id: UUID().uuidString, type: self.clothingType, itemImage: photo.image)
                    
                    picker.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                    self.coordinator?.startEditingDetails(forClothingItem: newItem)
                } else {
                    picker.dismiss(animated: true, completion: nil)
                }
            }
            present(picker, animated: true, completion: nil)
        }
    }
}
