//
//  ProfileUserTableViewCell.swift
//  WconnEct
//
//  Created by Ashish Malik on 10/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class ProfileUserTableViewCell: UITableViewCell {

    @IBOutlet weak var detailTextField: UITextField!
  
    @IBOutlet weak var iconLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
