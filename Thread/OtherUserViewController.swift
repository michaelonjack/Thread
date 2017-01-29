//
//  OtherUserViewController.swift
//  Thread
//
//  Created by Michael Onjack on 1/29/17.
//  Copyright © 2017 Michael Onjack. All rights reserved.
//

import UIKit

class OtherUserViewController: UIViewController {

    var otherUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "TopToClothingItem":
            let topVC: OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            topVC.clothingType = ClothingType.Top
            topVC.user = otherUser
        case "BottomToClothingItem":
            let bottomVC:OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            bottomVC.clothingType = ClothingType.Bottom
            bottomVC.user = otherUser
        case "ShoeToClothingItem":
            let shoeVC:OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            shoeVC.clothingType = ClothingType.Shoes
            shoeVC.user = otherUser
        case "AccessoryToClothingItem":
            let accessoryVC:OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            accessoryVC.clothingType = ClothingType.Accessories
            accessoryVC.user = otherUser
        default:
            let defaultVC:OtherUserClothingItemViewController = segue.destination as! OtherUserClothingItemViewController
            defaultVC.clothingType = nil
            defaultVC.user = nil
        }
    }

}
