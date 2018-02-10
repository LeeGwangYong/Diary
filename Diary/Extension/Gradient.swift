//
//  Gradient.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1).cgColor,
                                UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}

