//
//  DiaryDataManager.swift
//  Diary
//
//  Created by 박수현 on 17/01/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import Alamofire

class DiaryDataManager: NSObject {
    var currentUser: User?
    var isCurrentUser: Bool {
        get {
            return (self.currentUser != nil) ? true : false
        }
    }
    var friends: Friends?
    
    private struct StaticInstance {
        static var instance: DiaryDataManager?
    }
    static func getInstance() -> DiaryDataManager {
        if !(StaticInstance.instance != nil) {
            StaticInstance.instance = DiaryDataManager()
        }
        return StaticInstance.instance!
    }
}
