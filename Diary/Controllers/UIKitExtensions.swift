//
//  UIKitExtensions.swift
//  Diary
//
//  Created by 박수현 on 17/01/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import Foundation


extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
