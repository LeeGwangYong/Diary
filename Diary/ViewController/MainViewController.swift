//
//  MainViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 17..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class MainViewController: ViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var inputNavigateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewController()
    }
    
    override func setViewController() {
        inputNavigateView.isUserInteractionEnabled = true
        inputNavigateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateInputViewController)))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = """
yyyy년
M월 d일
"""
        dateFormatter.locale = Locale.current
        dateLabel.text = " \(dateFormatter.string(from: Date()))의 기억"
    }
    
    @objc func navigateInputViewController() {
        let nextVC = InputViewController(nibName: InputViewController.reuseIdentifier, bundle: nil)
        self.present(nextVC, animated: true, completion: nil)
    }
}
