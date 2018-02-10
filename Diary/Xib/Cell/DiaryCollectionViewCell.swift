//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 17..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class DiaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var opacityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        opacityView.alpha = 1
        // Initialization code
    }

}
