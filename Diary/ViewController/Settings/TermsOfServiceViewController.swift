//
//  TermsOfServiceViewController.swift
//  Diary
//
//  Created by 박수현 on 27/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
