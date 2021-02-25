//
//  NasiProjectCell.swift
//  NasiShadchanHelper
//
//  Created by username on 2/9/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

class NasiProjectCell: UITableViewCell {

   
    @IBOutlet weak var boysImageView: UIImageView!
    @IBOutlet weak var girlsImageView: UIImageView!
    @IBOutlet weak var girlsNameLabel: UILabel!
    @IBOutlet weak var boysNameLabel: UILabel!
    @IBOutlet weak var recentActivityUpdateLabel: UILabel!
    @IBOutlet weak var takeNextActionButton: UIButton!
    
    @IBOutlet weak var projectResultLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.red.cgColor
        
    }

   func configureCellForProject(currentProject: NasiMatch) {
    
        //currentProject.girlProfileImageURLPath
        //girlsImageView.image = UIIMage()
        
        //currentProject.ref
        //currentProject.key
        boysNameLabel.text = currentProject.boyFirstName + " " + currentProject.boyLastName
        //boysImageView.image = currentProject.b
        girlsNameLabel.text = currentProject.girlFirstName + " " + currentProject.girlLastName
        
        recentActivityUpdateLabel.text = "Emailed resume to \(currentProject.decisionMakerEmail)"
        recentActivityUpdateLabel.sizeToFit()
        projectResultLabel.text = currentProject.projectResult
        }

}
