//
//  ClothingItemViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/23/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class ClothingItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var labelViewTitle: UILabel!
    @IBOutlet weak var textFieldItemName: UITextField!
    @IBOutlet weak var textFieldItemBrand: UITextField!
    @IBOutlet weak var textFieldItemLink: UITextField!
    @IBOutlet weak var imageViewClothingPicture: UIImageView!
    
    let picker = UIImagePickerController()
    
    var clothingType: ClothingType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        switch clothingType! {
            case .Top:
                labelViewTitle.text = "shirt"
            case .Bottom:
                labelViewTitle.text = "pants"
            case .Shoes:
                labelViewTitle.text = "shoes"
            case .Accessories:
                labelViewTitle.text = "accessories"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraDidTouch(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picker.sourceType = UIImagePickerControllerSourceType.camera;
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        } else {
            print("not availableeeeeeeeeeeee")
        }
    }
    
    @IBAction func photoLibraryDidTouch(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageViewClothingPicture.contentMode = .scaleAspectFit //3
        imageViewClothingPicture.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
