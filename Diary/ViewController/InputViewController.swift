//
//  InputViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class InputViewController: ViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    var dateString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        
    }
    
    override func setViewController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "담아두기", style: UIBarButtonItemStyle.plain, target: self, action: #selector(selectKeepDay))
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        if let dateString = dateString  {
            self.dateLabel.text = dateString
        }
        self.textView.placeholder = "오늘은 어떤 기억을 담아둘까?"
        self.textView.tintColor = UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1)
    }

    @objc func selectKeepDay() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: KeepDayViewController.reuseIdentifier)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
        
    }
}
