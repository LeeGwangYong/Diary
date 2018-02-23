//
//  CompletionViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 23..
//  Copyright © 2018년 이광용. All rights reserved.
//
import UIKit

class CompletionViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    var delegate: KeepDayViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.createGradientLayer()
    }
}
