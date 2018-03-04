//
//  CustomTabBarController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 16..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UINavigationControllerDelegate {
    
    var bottomInset: CGFloat {
        if #available(iOS 11.0, *) {
            if let inset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                return inset
            }
        }
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = UIColor.white
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = UIColor.white
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1)
        } else {
            
            // Fallback on earlier versions
        }
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
        
        let size = CGSize(width: tabBar.frame.width/3, height: tabBar.frame.height +  bottomInset)
        let rect: CGRect = CGRect(x: 0, y: -self.bottomInset, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1).setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UITabBar.appearance().selectionIndicatorImage = image
    }
}

