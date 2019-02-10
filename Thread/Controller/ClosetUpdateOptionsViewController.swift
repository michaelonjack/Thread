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
    
    var clothingType: ClothingType!
    var searchDashedBorder: CAShapeLayer?
    var cameraDashedBorder: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        searchView.layer.cornerRadius = searchView.frame.height / 6.0
        searchView.layer.borderColor = UIColor.white.cgColor
        searchView.layer.borderWidth = 3
        searchView.clipsToBounds = true
        
        cameraView.layer.cornerRadius = cameraView.frame.height / 6.0
        cameraView.layer.borderColor = UIColor.white.cgColor
        cameraView.layer.borderWidth = 3
        cameraView.clipsToBounds = true
    }

    @IBAction func chooseSearchOption(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        coordinator?.searchClothingItems()
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
