//
//  KeyCell.swift
//  NasiShadchanHelper
//
//  Created by username on 1/22/21.
//  Copyright © 2021 user. All rights reserved.
//

import UIKit

class KeyCell: UICollectionViewCell {
    
     
        let digitsLabel = UILabel()
        let lettersLabel = UILabel()
        
        fileprivate let defaultBGColor = UIColor(white: 0.9, alpha: 1)
        
        override var isHighlighted: Bool {
            didSet {
                backgroundColor = isHighlighted ? .darkGray : defaultBGColor
                digitsLabel.textColor = isHighlighted ? .white : .black
                lettersLabel.textColor = isHighlighted ? .white : .black
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = defaultBGColor
            
            digitsLabel.text = "8"
            digitsLabel.textColor = UIColor.link
            
            digitsLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 24) : .systemFont(ofSize: 32)
            
            digitsLabel.textAlignment = .center
            
            lettersLabel.text = "A B C"
            lettersLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .boldSystemFont(ofSize: 8) : .boldSystemFont(ofSize: 10)
            lettersLabel.textAlignment = .center
            
            let stackView = UIStackView(arrangedSubviews: [digitsLabel, lettersLabel])
            stackView.axis = .vertical
            
            addSubview(stackView)
            stackView.centerInSuperview()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            layer.cornerRadius = self.frame.width / 2
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    extension UIDevice {
        var iPhoneX: Bool {
            return UIScreen.main.nativeBounds.height == 2436
        }
        var iPhone: Bool {
            return UIDevice.current.userInterfaceIdiom == .phone
        }
        enum ScreenType: String {
            case iPhones_4_4S = "iPhone 4 or iPhone 4S"
            case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
            case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
            case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
            case iPhones_X_XS = "iPhone X or iPhone XS"
            case iPhone_XR = "iPhone XR"
            case iPhone_XSMax = "iPhone XS Max"
            case unknown
        }
        var screenType: ScreenType {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                return .iPhones_4_4S
            case 1136:
                return .iPhones_5_5s_5c_SE
            case 1334:
                return .iPhones_6_6s_7_8
            case 1792:
                return .iPhone_XR
            case 1920, 2208:
                return .iPhones_6Plus_6sPlus_7Plus_8Plus
            case 2436:
                return .iPhones_X_XS
            case 2688:
                return .iPhone_XSMax
            default:
                return .unknown
            }
        }
    }
