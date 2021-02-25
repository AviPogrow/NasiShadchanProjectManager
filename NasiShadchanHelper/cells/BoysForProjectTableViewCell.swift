//
//  BoysForProjectTableViewCell.swift
//  NasiShadchanHelper
//
//  Created by username on 2/20/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

class BoysForProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var searchNasiGirlsLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var secondNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
