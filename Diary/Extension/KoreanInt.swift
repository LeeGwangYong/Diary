//
//  KoreanInt.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

extension Int {
    func korean() -> String {
        switch self {
        case 0: return "영"
        case 1: return "한"
        case 2: return "두"
        case 3: return "세"
        case 4: return "네"
        case 5: return "다섯"
        case 6: return "여섯"
        case 7: return "일곱"
        case 8: return "여덟"
        case 9: return "아홉"
            
        default: return ""
        }
    }
    func koreanString() -> String {
        return ""
    }
}
