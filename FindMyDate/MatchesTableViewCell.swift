//
//  MatchesTableViewCell.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-07-26.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var profileHolder: UIImageView!
    //@IBOutlet weak var imageHolder: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileHolder?.layer.borderWidth = 1
        profileHolder?.layer.masksToBounds = false
        profileHolder?.layer.borderColor = UIColor.black.cgColor
        profileHolder?.layer.cornerRadius = profileHolder.frame.height/2
        profileHolder?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
