//
//  UsersTableViewCellHeader.swift
//  Thread
//
//  Created by Michael Onjack on 6/16/18.
//  Copyright © 2018 Michael Onjack. All rights reserved.
//

import UIKit

protocol UsersTableViewCellHeaderDelegate: class {
    func dismissTable()
}

class UsersTableViewCellHeader: UITableViewCell {

    weak var delegate: UsersTableViewCellHeaderDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        delegate?.dismissTable()
    }
}
