//
//  TeachersTableViewCell.swift
//  WconnEct
//
//  Created by Ashish Malik on 17/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class TeachersTableViewCell: UITableViewCell
{

    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var qualificationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var experienceLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addToWishListButton: UIButton!
    
    var addedToWishList : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
