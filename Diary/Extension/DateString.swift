//
//  DateString.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 18..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

extension Date {
    func dateToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일의 기억"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}
