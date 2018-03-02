//
//  EnumHashable.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 23..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

protocol EnumCollection : Hashable {
    var description: String { get }
}

extension EnumCollection {
    
    private static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var index = 0
        
        let closure: () -> T? = {
            let next = withUnsafePointer(to: &index) {
                $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
            }
            guard next.hashValue == index else { return nil }
            index += 1
            return next
        }
        
        return AnyIterator(closure)
    }
    
    static var allCases: [Self] {
        return iterateEnum(self).map { $0 }
    }
    
    static var allDescription: [String] {
        return iterateEnum(self).map { $0.description }
    }
}
