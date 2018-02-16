//
//  InputViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class InputViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
    }
    
    override func setViewController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "담아두기", style: UIBarButtonItemStyle.plain, target: self, action: #selector(selectKeepDay))
        self.navigationItem.backBarButtonItem?.title = ""
    }

    @objc func selectKeepDay() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: KeepDayViewController.reuseIdentifier)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
