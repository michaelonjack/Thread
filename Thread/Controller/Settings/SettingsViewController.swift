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
    
    lazy var profilePictureButton1: UIButton = createProfilePictureButton()
    lazy var profilePictureButton2: UIButton = createProfilePictureButton()
    lazy var profilePictureButton3: UIButton = createProfilePictureButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationImage = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysTemplate)
        navigationButton.setImage(navigationImage, for: .normal)
        navigationButton.tintColor = .white

        settingsTableView.delegate = self
        
        loadInitialUserValues()
    }

    @IBAction func dismissSettings(_ sender: Any) {
        coordinator?.pop()
    }
    
    fileprivate func loadInitialUserValues() {
        guard let currentUser = configuration.currentUser else { return }
        
        settingsTableView.rowData[1][0].1 = currentUser.firstName
        settingsTableView.rowData[1][1].1 = currentUser.lastName
        settingsTableView.rowData[1][2].1 = currentUser.email
        
        currentUser.getProfilePicture(index: 0) { (profilePicture) in
            self.profilePictureButton1.setImage(profilePicture, for: .normal)
        }
        
        currentUser.getProfilePicture(index: 1) { (profilePicture2) in
            self.profilePictureButton2.setImage(profilePicture2, for: .normal)
        }
        
        currentUser.getProfilePicture(index: 2) { (profilePicture3) in
            self.profilePictureButton3.setImage(profilePicture3, for: .normal)
        }
        
        settingsTableView.reloadData()
    }
    
    @objc func updateProfilePicture(using button: UIButton) {
        
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
                    var uploadPath = ""
                    
                    switch button {
                    case self.profilePictureButton1:
                        uploadPath = "images/" + currentUser.uid + "/ProfilePicture"
                    case self.profilePictureButton2:
                        uploadPath = "images/" + currentUser.uid + "/ProfilePicture2"
                    case self.profilePictureButton3:
                        uploadPath = "images/" + currentUser.uid + "/ProfilePicture3"
                    default:
                        break
                    }
                    
                    uploadImage(toLocation: uploadPath, image: photo.image, completion: { (url, error) in
                        if error == nil {
                            switch button {
                            case self.profilePictureButton1:
                                currentUser.profilePicture = photo.image
                                currentUser.profilePictureUrl = url
                                
                                self.profilePictureButton1.setImage(photo.image, for: .normal)
                                
                                // Cache the profile picture
                                UserDefaults.standard.setValue(photo.image.jpegData(compressionQuality: 1), forKey: currentUser.uid + "-profilePicture")
                            case self.profilePictureButton2:
                                currentUser.profilePicture2 = photo.image
                                currentUser.profilePictureUrl2 = url
                                
                                self.profilePictureButton2.setImage(photo.image, for: .normal)
                            case self.profilePictureButton3:
                                currentUser.profilePicture3 = photo.image
                                currentUser.profilePictureUrl3 = url
                                
                                self.profilePictureButton3.setImage(photo.image, for: .normal)
                            default:
                                break
                            }
                            
                            currentUser.save()
                        }
                    })
                }
                
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
    }
    
    fileprivate func createProfilePictureButton() -> UIButton {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.cornerRadius = 8
        b.clipsToBounds = true
        b.imageView?.contentMode = .scaleAspectFill
        b.setTitle("Add photo", for: .normal)
        b.setTitleColor(.lightGray, for: .normal)
        b.addTarget(self, action: #selector(updateProfilePicture(using:)), for: .touchUpInside)
        
        return b
    }
}



extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = UIView()
            
            let outerPictureStackView = UIStackView()
            outerPictureStackView.translatesAutoresizingMaskIntoConstraints = false
            outerPictureStackView.axis = .horizontal
            outerPictureStackView.distribution = .fillEqually
            outerPictureStackView.spacing = 16
            outerPictureStackView.isLayoutMarginsRelativeArrangement = true
            outerPictureStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            
            let innerPictureStackView = UIStackView()
            innerPictureStackView.axis = .vertical
            innerPictureStackView.distribution = .fillEqually
            innerPictureStackView.spacing = 16
            
            innerPictureStackView.addArrangedSubview(profilePictureButton2)
            innerPictureStackView.addArrangedSubview(profilePictureButton3)
            
            outerPictureStackView.addArrangedSubview(profilePictureButton1)
            outerPictureStackView.addArrangedSubview(innerPictureStackView)
            
            headerView.addSubview(outerPictureStackView)
            
            NSLayoutConstraint.activate([
                outerPictureStackView.topAnchor.constraint(equalTo: headerView.topAnchor),
                outerPictureStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                outerPictureStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                outerPictureStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
            ])
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowName = settingsTableView.rowData[indexPath.section][indexPath.row].0
        
        switch selectedRowName {
        case "First Name":
            coordinator?.startEditingUserName()
        case "Last Name":
            coordinator?.startEditingUserName()
        case "Email":
            coordinator?.startEditingEmail()
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
        // Make the section headers have white text with dark gray background
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
            headerView.backgroundView = backgroundView
        }
    }
}
