//
//  MainViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 17..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class MainViewController: ViewController {
    //MARK -: Property
    @IBOutlet weak var blinkingView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var inputNavigateView: UIView!
    @IBOutlet weak var capsuleTableView: UITableView!
    @IBOutlet weak var capsuleCountLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK -: Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.inputNavigateView.createGradientLayer()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.blinkingView.alpha = 1.0}, completion: nil)
        
        let attributedString = NSMutableAttributedString(string: "다섯 개의 기억이\n타임캡슐에 담겨있습니다.")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold ), range: NSRange(location: 0, length: 4))
        self.capsuleCountLabel.attributedText = attributedString
    }
    
    override func setViewController() {
        self.inputNavigateView.isUserInteractionEnabled = true
        self.capsuleTableView.setUp(target: self, cell: CapsuleTableViewCell.self)
        self.inputNavigateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateInputViewController)))
        var currentDateString = Date().dateToString()
        currentDateString.insert("\n", at: currentDateString.index(currentDateString.startIndex, offsetBy: 6)) //currentDateString.insert("\n", at:  )
        self.dateLabel.text = currentDateString
        self.blinkingView.alpha = 0.2
        
    }
    
    @objc func navigateInputViewController() {
        let nextVC: InputViewController = InputViewController(nibName: InputViewController.reuseIdentifier, bundle: nil)
        nextVC.dateString = self.dateLabel.text
        self.present(nextVC, animated: true, completion: nil)
    }
}

//MARK -: Extension
//MARK : TableViewDelegate, TabelViewDatasource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CapsuleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y <= 0 {
            self.bottomConstraint.constant = 97
            self.topConstraint.constant = 0
            
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
                self.dateLabel.isHidden = false
            }
        }
        else {
            self.bottomConstraint.constant = 20
            self.topConstraint.constant = -156
            
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
                self.dateLabel.isHidden = true
            }
            
        }
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
}
