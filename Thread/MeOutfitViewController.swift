//
//  MeOutfitViewController.swift
//  Thread
//
//  Created by Michael Onjack on 6/24/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import YPImagePicker
import CoreLocation
import AudioToolbox
import NotificationBannerSwift


class MeOutfitViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var textFieldStatus: UITextField!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var imageViewOutfit: UIImageView!
    @IBOutlet weak var topInfoView: UIView!
    
    @IBOutlet weak var imageWidthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var outfitTopLayout: NSLayoutConstraint!
    
    // LocationManager instance used to update the current user's location
    let locationManager = CLLocationManager()
    
    var locationBanner:StatusBarNotificationBanner = StatusBarNotificationBanner(attributedTitle: NSAttributedString(string: "Updating location..."), style: .warning)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor.init(red: 1.000, green: 0.568, blue: 0.196, alpha: 1.000)
        ]
        
        outfitTopLayout.constant = 8 * (UIScreen.main.bounds.height/667)
        
        // Adjust outfit picture size for different displays
        scaleConstraintMultiplierForWidth(constraint: imageWidthLayout, originalWidth: 375, parentView: self.view!)
        
        // Makes the profile picture button circular
        imageViewProfilePicture.contentMode = .scaleAspectFill
        imageViewProfilePicture.layer.cornerRadius = 0.5 * imageViewProfilePicture.layer.bounds.width
        imageViewProfilePicture.clipsToBounds = true
        
        loadData()
        detectFirstLaunch()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutfitToFollowing" {
            let followingController: UserTableViewController = segue.destination as! UserTableViewController
            followingController.forAroundMe = false
        }
    }
    
    
    
    func loadData() {
    
        getDataForUser(userid: (Auth.auth().currentUser?.uid)!, completion: { (userData) in
            let fname = userData["firstName"] as? String ?? ""
            let lname = userData["lastName"] as? String ?? ""
            let name = fname + " " + lname
            
            let city = userData["location"]?["city"] as? String ?? ""
            let state = userData["location"]?["state"] as? String ?? ""
            let locationStr = city + ", " + state
            
            let status = userData["status"] as? String ?? ""
            
            let outfitPicUrlStr = userData["outfitPictureUrl"] as? String ?? ""
            if outfitPicUrlStr != "" {
                let outfitPicUrl = URL(string: outfitPicUrlStr)
                self.imageViewOutfit.sd_setImage(with: outfitPicUrl)
            }
            
            let profilePicUrlStr = userData["profilePictureUrl"] as? String ?? ""
            if profilePicUrlStr != "" {
                let profilePicUrl = URL(string: profilePicUrlStr)
                self.imageViewProfilePicture.sd_setImage(with: profilePicUrl, placeholderImage: UIImage(named: "Avatar"))
            }
            
            DispatchQueue.main.async {
                self.labelName.text = name
                self.labelLocation.text = locationStr
                self.textFieldStatus.text = status
            }
        })
    
    }
    
    func detectFirstLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "OutfitToInstructions", sender: nil)
            }
        }
    }
    
    @IBAction func cameraDidTouch(_ sender: UIButton) {
        
        var ypConfig = YPImagePickerConfiguration()
        ypConfig.onlySquareImagesFromCamera = true
        ypConfig.library.onlySquare = true
        ypConfig.showsFilters = true
        ypConfig.library.mediaType = .photo
        ypConfig.usesFrontCamera = false
        ypConfig.shouldSaveNewPicturesToAlbum = false
        
        let picker = YPImagePicker(configuration: ypConfig)
        picker.didFinishPicking { items, _ in
            if let photo = items.singlePhoto {
                self.imageViewOutfit.image = photo.image
                uploadOutfitPictureForUser(userid: (Auth.auth().currentUser?.uid)!, image: photo.image)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func statusUpdated(_ sender: Any) {
        updateDataForUser(userid: (Auth.auth().currentUser?.uid)!, key: "status", value: self.textFieldStatus.text as AnyObject)
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  checkIn
    //
    //  Checks in the user's current location
    //
    @IBAction func checkIn(_ sender: UIButton) {
        
        if locationServiceIsEnabled() {
            self.locationBanner.show()
            
            self.locationManager.delegate = self
            // Request location authorization for the app
            self.locationManager.requestWhenInUseAuthorization()
            // Request a location update
            self.locationManager.requestLocation()
        }
        
        else {
            let locationNotEnabledAlert = UIAlertController(title: "Location Services Disabled",
                                                     message: "Location Services must be enabled to check in with Thread.",
                                                     preferredStyle: .alert)
            // Close action closes the pop-up alert
            let closeAction = UIAlertAction(title: "Close", style:.default)
            
            locationNotEnabledAlert.addAction(closeAction)
            
            self.present(locationNotEnabledAlert, animated: true, completion: nil)
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  locationServiceIsEnabled
    //
    //  Returns true if the user has location services enabled, false otherwise
    //
    func locationServiceIsEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
            }
        } else {
            return false
        }
    }
    
    
    
    /////////////////////////////////////////////////////
    //
    //  locationManager
    //
    //  Updates the user's latitude and longitude values in the Firebase database
    //  Implicitly called by viewDidLoad when requesting the location
    //
    // Process the received location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Grab latitude and longitude
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        // Update the user's location in the database
        updateDataForUser(userid: (Auth.auth().currentUser?.uid)!, key: "latitude", value: locValue.latitude as AnyObject)
        
        updateDataForUser(userid: (Auth.auth().currentUser?.uid)!, key: "longitude", value: locValue.longitude as AnyObject)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let dateStr = formatter.string(from: date) + " " + String(hour) + ":" + String(minutes)
         updateDataForUser(userid: (Auth.auth().currentUser?.uid)!, key: "lastCheckIn", value: dateStr as AnyObject)
        
        self.locationBanner.dismiss()
        let successBanner = NotificationBanner(attributedTitle: NSAttributedString(string: "Checked In!"), attributedSubtitle: NSAttributedString(string: "You can now see other Thread users around you."), style: .success)
        successBanner.show()
        
        // Vibrate the phone to signify a successful check-in
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    // Process any errors that may occur when gathering location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    

}
