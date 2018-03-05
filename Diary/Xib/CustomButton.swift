//
//  CustomButton.swift
//  Diary
//
//  Created by 이광용 on 2018. 3. 5..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    func setUpUI(){
        self.setTitleColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0), for: .disabled)
        self.setBackgroundImage(UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).createImageView(size: self.frame.size), for: .disabled)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setBackgroundImage(UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0).createImageView(size: self.frame.size), for: .normal)
        self.makeRoundedView(corners: [.allCorners], radius: 5)
    }
}
