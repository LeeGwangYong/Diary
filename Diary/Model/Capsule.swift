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
import ObjectMapper

enum RealmState {
    case add, remove
}

protocol Realmable {}
extension Object: Realmable {}
extension Results: Realmable {}
class CapsuleResponse: Mappable {
    var code: String = ""
    var capsule: [Capsule]?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        capsule <- map["data"]
    }
}

class Capsule: Object, Mappable  {

    @objc dynamic var idx: Int = 0
    @objc dynamic var userIdx: Int = 0
    @objc dynamic var contents: String = ""
    @objc dynamic var insertDate: Date = Date()
    @objc dynamic var openDate: Date = Date()
    @objc dynamic var updateDate: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        idx <- map["idx"]
        userIdx <- map["user_idx"]
        contents <- map["contents"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterTransform = DateFormatterTransform(dateFormatter: dateFormatter)
        insertDate <- (map["insert_date"], dateFormatterTransform)
        openDate <- (map["open_date"], dateFormatterTransform)
        updateDate <- (map["udate_date"], dateFormatterTransform)

    }
    

    
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
    
    
    ///Primary Key를 등록해 줍니다.
    override static func primaryKey() -> String? {
        return "idx"
    }
    
    static func write<T>(_ item: T, state: RealmState) where T: Realmable {
        do {

            try self.realm?.write {
                switch state {
                case .add :
                    self.realm?.add(item as! Object, update: true)
                case .remove :
                    self.realm?.delete(item as! Results<Capsule>)
                }
            }
        }
        catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    static func removeAll() {
        let realm: Realm = try! Realm()
        do {
            try realm.write {
                realm.deleteAll()
            }
        }
        catch(let err) {
            print(err.localizedDescription)
        }
    }
}
