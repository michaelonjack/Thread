//
//  OtherUserOutfitViewController.swift
//  Thread
//
//  Created by Michael Onjack on 6/24/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class OtherUserOutfitViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var imageViewOutfit: UIImageView!
    
    var otherUser: User!
    var userRef: DatabaseReference!
    var userStorageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Makes the profile picture button circular
        imageViewProfilePicture.contentMode = .scaleAspectFill
        imageViewProfilePicture.layer.cornerRadius = 0.5 * imageViewProfilePicture.layer.bounds.width
        imageViewProfilePicture.clipsToBounds = true
        
        loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func followDidTouch(_ sender: UIButton) {
        
    }
    
    
    
    func loadData() {
        
        getDataForUser(userid: otherUser.uid, completion: { (userData) in
            let fname = userData["firstName"] as? String ?? ""
            let lname = userData["lastName"] as? String ?? ""
            let name = fname + " " + lname
            let status = userData["status"] as? String ?? "No status"
            
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
                self.labelStatus.text = status
            }
        })
        
    }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let otherUserVC: OtherUserContainerViewController = segue.destination as! OtherUserContainerViewController
        otherUserVC.otherUser = self.otherUser
    }
}
