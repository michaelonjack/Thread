//
//  MeOutfitViewController.swift
//  Thread
//
//  Created by Michael Onjack on 6/24/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit
import Fusuma
import CoreLocation
import AudioToolbox


class MeOutfitViewController: UIViewController, FusumaDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var textFieldStatus: UITextField!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var imageViewOutfit: UIImageView!
    @IBOutlet weak var topInfoView: UIView!
    
    @IBOutlet weak var imageWidthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var outfitTopLayout: NSLayoutConstraint!
    @IBOutlet weak var cameraButtonTopLayout: NSLayoutConstraint!
    @IBOutlet weak var checkInTopLayout: NSLayoutConstraint!
    @IBOutlet weak var outfitButtonTopLayout: NSLayoutConstraint!
    
    // LocationManager instance used to update the current user's location
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIScreen.main.bounds.height/667)
        print(24 * (UIScreen.main.bounds.height/667))
        cameraButtonTopLayout.constant = 29 * (UIScreen.main.bounds.height/667)
        checkInTopLayout.constant = 24 * (UIScreen.main.bounds.height/667)
        outfitButtonTopLayout.constant = 24 * (UIScreen.main.bounds.height/667)
        outfitTopLayout.constant = 8 * (UIScreen.main.bounds.height/667)
        
        // Adjust outfit picture size for different displays
        scaleConstraintMultiplierForWidth(constraint: imageWidthLayout, originalWidth: 375, parentView: self.view!)
        

        // Makes the profile picture button circular
        imageViewProfilePicture.contentMode = .scaleAspectFill
        imageViewProfilePicture.layer.cornerRadius = 0.5 * imageViewProfilePicture.layer.bounds.width
        imageViewProfilePicture.clipsToBounds = true
        
        loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        imageViewOutfit.image = image
        uploadOutfitPictureForUser(userid: (Auth.auth().currentUser?.uid)!, image: image)
        
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {}
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {}
    func fusumaCameraRollUnauthorized() {}
    func fusumaClosed() {}
    func fusumaWillClosed() {}
    
    @IBAction func cameraDidTouch(_ sender: UIButton) {
        
        // Check if camera is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let fusuma = FusumaViewController()
            fusuma.delegate = self
            fusuma.cropHeightRatio = 0.8
            fusuma.hasVideo = true
            fusuma.defaultMode = .library
            fusuma.allowMultipleSelection = false
            fusumaSavesImage = true
            
            self.present(fusuma, animated: true, completion: nil)
        } else {
            let notAvailableAlert = UIAlertController(title: "Camera Not Available",
                                               message: "Your device's camera is not available",
                                               preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .default)
            notAvailableAlert.addAction(closeAction)
            self.present(notAvailableAlert, animated: true, completion:nil)
        }
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
        
        // Vibrate the phone to signify a successful check-in
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    // Process any errors that may occur when gathering location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    

}
