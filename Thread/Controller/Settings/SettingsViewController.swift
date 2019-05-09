//
//  SettingsViewController.swift
//  Thread
//
//  Created by Michael Onjack on 2/22/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import UIKit
import YPImagePicker

class SettingsViewController: UIViewController, Storyboarded {
    
    weak var coordinator: ActiveUserCoordinator?

    @IBOutlet weak var settingsTableView: SettingsTableView!
    @IBOutlet weak var navigationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationImage = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysTemplate)
        navigationButton.setImage(navigationImage, for: .normal)
        navigationButton.tintColor = .white

        settingsTableView.delegate = self
    }

    @IBAction func dismissSettings(_ sender: Any) {
        coordinator?.pop()
    }
    
    func updateProfilePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) || UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var ypConfig = YPImagePickerConfiguration()
            ypConfig.onlySquareImagesFromCamera = true
            ypConfig.library.onlySquare = true
            ypConfig.showsPhotoFilters = true
            ypConfig.library.mediaType = .photo
            ypConfig.usesFrontCamera = false
            ypConfig.shouldSaveNewPicturesToAlbum = false
            
            let picker = YPImagePicker(configuration: ypConfig)
            picker.didFinishPicking { (items, _) in
                if let photo = items.singlePhoto, let currentUser = configuration.currentUser {
                    uploadImage(toLocation: "images/" + currentUser.uid + "/ProfilePicture", image: photo.image, completion: { (url, error) in
                        if error == nil {
                            currentUser.profilePicture = photo.image
                            currentUser.profilePictureUrl = url
                            currentUser.save()
                            
                            // Cache the profile picture
                            UserDefaults.standard.setValue(photo.image.jpegData(compressionQuality: 1), forKey: currentUser.uid + "-profilePicture")
                        }
                    })
                }
                
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
    }
}



extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowName = settingsTableView.rowData[indexPath.section][indexPath.row].0
        
        switch selectedRowName {
        case "First Name":
            coordinator?.startEditingUserName()
        case "Last Name":
            coordinator?.startEditingUserName()
        case "Email":
            coordinator?.startEditingEmail()
        case "Profile Picture":
            updateProfilePicture()
        case "Logout":
            coordinator?.logout()
        case "Change Password":
            coordinator?.startEditingPassword()
        case "Terms of Service":
            coordinator?.viewTermsOfService()
        case "Privacy Policy":
            coordinator?.viewPrivacyPolicy()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
            headerView.backgroundView = backgroundView
        }
    }
}
