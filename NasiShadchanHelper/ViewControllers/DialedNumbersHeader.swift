//
//  DialedNumbersHeader.swift
//  NasiShadchanHelper
//
//  Created by username on 1/22/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

class DialedNumbersHeader: UICollectionReusableView {
          let numbersLabel = UILabel()
            
            override init(frame: CGRect) {
                super.init(frame: frame)
                
                numbersLabel.text = "123"
                numbersLabel.font = UIFont.systemFont(ofSize: 32)
                numbersLabel.textAlignment = .center
                numbersLabel.adjustsFontSizeToFitWidth = true
                addSubview(numbersLabel)
                numbersLabel.fillSuperview(padding: .init(top: 0, left: 32, bottom: 0, right: 32))
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError()
            }
            
        }
