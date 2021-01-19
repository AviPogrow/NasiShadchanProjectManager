//
//  GirlSentCell.swift
//  NasiShadchanHelper
//
//  Created by username on 12/17/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class GirlSentCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

          // Initialization code
              let selection = UIView(frame: CGRect.zero)
              selection.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
              selectedBackgroundView = selection
              // Rounded corners for images
              //profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
              //profileImageView.clipsToBounds = true
    }

}
