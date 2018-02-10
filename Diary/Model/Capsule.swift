//
//  CapsuleStruct.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 18..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

enum RealmState {
    case add, remove
}

class Capsule: Object {
    static var realm: Realm? {
        do {
            //Migration
            return try Realm()
        }
        catch(let err) {
            print(err.localizedDescription)
        }
        return nil
    }
    
    @objc dynamic var date: Date = Date()
    @objc dynamic var content: String = ""
    
    ///Primary Key를 등록해 줍니다.
    override static func primaryKey() -> String? {
        return "date"
    }
    
    static func write<T: Capsule>(_ item: T, state: RealmState) {
        let realm = try! Realm()
        do {
            try realm.write {
                switch state {
                case .add :
                    let preItems = realm.objects(Capsule.self).filter("date = %@", item.date)
                    if let preItem = preItems.first {
                        preItem.content = item.content
                    }
                    else { realm.add(item) }
                case .remove :
                    realm.delete(item)
                }
            }
        }
        catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    static func removeAll() {
        let realm: Realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
