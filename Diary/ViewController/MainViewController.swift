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
    
    override func viewWillAppear(_ animated: Bool) {
        inputNavigateView.createGradientLayer()
    }
    
    override func setViewController() {
        inputNavigateView.isUserInteractionEnabled = true
        inputNavigateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateInputViewController)))
        let currentDateString = Date().dateToString()
        dateLabel.text = currentDateString//.insert("\n", at:  ) //currentDateString.insert("\n", at:  )
    }
    
    @objc func navigateInputViewController() {
        let nextVC: InputViewController = InputViewController(nibName: InputViewController.reuseIdentifier, bundle: nil)
        nextVC.dateString = self.dateLabel.text
        self.present(nextVC, animated: true, completion: nil)
    }
}
