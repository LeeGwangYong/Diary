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
    
    func update(insertDate: Date, openDate: Date,content: String) {
        var insertDateString = insertDate.dateToStringYMD()
        insertDateString.insert("\n", at: insertDateString.index(insertDateString.startIndex, offsetBy: 6))
        let attributedString = NSMutableAttributedString(string: "\(insertDateString)의 기억")
        
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .bold ), range: NSRange(location: 0, length: 5 ))
        self.dateLabel.attributedText = attributedString
        
        self.contentLabel.text = content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
