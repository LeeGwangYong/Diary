//
//  UserInfo.swift
//  Diary
//
//  Created by 박수현 on 26/01/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class UserInfo: Object {
  
    //dynamic var name: String = ""
    dynamic var email: String = ""
    dynamic var password: String = ""
    //dynamic var profile = UIImage(named: "account.jpg")
    
    convenience init(email: String, password: String){
        self.init()
       // self.name = name
        self.email = email
        self.password = password
       // self.profile = profile
    }
    /*
     static var realm: Realm{
     return try! Realm()
     }
     */
   /*
    override static func primaryKey() -> String? {
        return "account"
    }
    
    static func addToRealm<T: Object>(_ item: T) {
        try! realm.write {
            realm.add(item)
        }
    }
    
    static func removeFromRealm<T:Object>(_ item: T) {
        try! realm.write {
            realm.delete(item)
        }
    }
    
    static func removeFromAllRealm() {
        let realm: Realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
 */
}
