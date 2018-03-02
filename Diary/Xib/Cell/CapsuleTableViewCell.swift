//
//  CapsuleTableViewCell.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class CapsuleTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var gradiantView: UIView!
    
    func update(insertDate: Date, openDate: Date, opened: Bool = false, content: String) {
        var insertDateString = insertDate.dateToStringYMD()
        insertDateString.insert("\n", at: insertDateString.index(insertDateString.startIndex, offsetBy: 6))
        let attributedString = NSMutableAttributedString(string: "\(insertDateString)의 기억")
        
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .bold ), range: NSRange(location: 0, length: 5 ))
        self.dateLabel.attributedText = attributedString
        
        let formatter = DateFormatter()
        formatter.dateFormat =  opened ? "yyyy.MM.dd 꺼냄" : "M월 dd일 꺼내기"
        var dDayString: String = formatter.string(from: openDate)
        for division in DivisionOfTheYear.allCases {
            if let date = division.date, openDate.compare(date) == .orderedSame {
                dDayString = "\(division.description) \(opened ? "꺼냄" : "꺼내기")"
            }
        }
        
        if !opened {
            if Date().calculateDDay(to: openDate) == 0 {
                dDayString += ", D-Day"
            }
            else {dDayString += ", D-\(Date().calculateDDay(to: openDate))"}
        }
        self.dDayLabel.text = dDayString
        
        
        self.contentLabel.text = content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutIfNeeded() {
        
        super.layoutIfNeeded()
        self.gradiantView.createGradientLayer()
    }
}
