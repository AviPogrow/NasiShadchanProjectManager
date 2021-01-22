//
//  BackspaceCell.swift
//  NasiShadchanHelper
//
//  Created by username on 1/22/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

class BackspaceCell: UICollectionViewCell {
    
       let imageView = UIImageView(image: #imageLiteral(resourceName: "phone_backspace"))
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
    //        backgroundColor = .red
            
            imageView.contentMode = .scaleAspectFit
            addSubview(imageView)
            imageView.centerInSuperview(size: .init(width: 40, height: 40))
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = frame.width / 2
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
        
    }
