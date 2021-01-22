//
//  GreenCallButtonCell.swift
//  NumPadLBTA
//
//  Created by Brian Voong on 3/20/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

class GreenCallButtonCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        

        let imageCam = UIImage(named: "imgBack")
        let imageView = UIImageView(image: imageCam)
        
        
        backgroundColor = #colorLiteral(red: 0.297358036, green: 0.8514089584, blue: 0.389008224, alpha: 1)
        
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
