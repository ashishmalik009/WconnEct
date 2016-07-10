//
//  GenderProfileTableViewCell.swift
//  WconnEct
//
//  Created by Anahita Kapoor on 19/04/1938 Saka.
//  Copyright © 1938 Saka wconnect. All rights reserved.
//

import UIKit

class GenderProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
