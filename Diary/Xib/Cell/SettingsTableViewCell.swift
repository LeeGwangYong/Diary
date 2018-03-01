//
//  SettingsTableViewCell.swift
//  Diary
//
//  Created by 박수현 on 26/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
