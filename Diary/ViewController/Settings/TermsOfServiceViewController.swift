//
//  TermsOfServiceViewController.swift
//  Diary
//
//  Created by 박수현 on 27/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
    }
}
