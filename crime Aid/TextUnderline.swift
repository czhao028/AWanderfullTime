//
//  TextUnderline.swift
//  crime Aid
//
//  Created by Cassy on 11/9/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    
    func underline(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
