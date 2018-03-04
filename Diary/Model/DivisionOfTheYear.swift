//
//  DivisionOfTheYear.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 23..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

enum DivisionOfTheYear: EnumCollection {
    case select, spring, summer, autumn, winter, lastDay, nextFirst, random
    
    var description: String {
        switch  self {
        case .select:
            return "달력에서 직접 선택"
        case .spring:
            return "봄이 시작되는 날"
        case .summer:
            return "여름이 시작되는 날"
        case .autumn:
            return "가을이 시작되는 날"
        case .winter:
            return "겨울이 시작되는 날"
        case .lastDay:
            return "올해의 마지막 날"
        case .nextFirst:
            return "첫 날"
        case .random:
            return "아무때나"
        }
    }
    
    var date: Date? {
        let customCalendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.timeZone = customCalendar.timeZone
        dateComponents.year = customCalendar.component(.year, from: Date())
        switch self {
        case .spring:
            dateComponents.year! += 1
            dateComponents.month = 2
            dateComponents.day = 3
        case .summer:
            dateComponents.year! += 1
            dateComponents.month = 5
            dateComponents.day = 5
        case .autumn:
            dateComponents.year! += 1
            dateComponents.month = 8
            dateComponents.day = 7
        case .winter:
            dateComponents.year! += 1
            dateComponents.month = 11
            dateComponents.day = 7
        case .lastDay:
            dateComponents.month = 12
            dateComponents.day = 31
        case .nextFirst:
            dateComponents.year! += 1
            dateComponents.month = 1
            dateComponents.day = 1
        case .select: return nil
        case .random:
            return customCalendar.date(byAdding: .day, value: Int(arc4random_uniform(365) + 1) , to: Date())
        }
        return customCalendar.date(from: dateComponents) ?? Date()
        
    }
}
