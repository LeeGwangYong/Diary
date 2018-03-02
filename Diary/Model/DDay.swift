//
//  DDay.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 24..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

extension Date {
    func calculateDDay(to: Date) -> Int {
        let fromDate = Calendar.current.startOfDay(for: self)
        let toDate = Calendar.current.startOfDay(for: to)
        let components = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        if let days = components.day {
            return days
        }
        return 0
    }
}
