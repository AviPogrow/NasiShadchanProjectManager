//
//  AllGirlsTableViewCell.swift
//  NasiShadchanHelper
//
//  Created by username on 1/12/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

class AllGirlsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
