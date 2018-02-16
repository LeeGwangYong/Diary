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
        self.setUpTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transparentNavigationBar()
        
        self.blinkingView.alpha = 0.2
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.blinkingView.alpha = 1.0}, completion: nil)
        let attributedString = NSMutableAttributedString(string: "다섯 개의 기억이\n타임캡슐에 담겨있습니다.")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold ), range: NSRange(location: 0, length: 4))
        self.capsuleCountLabel.attributedText = attributedString
        self.inputNavigateView.createGradientLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.inputNavigateView.createGradientLayer()
    }
    
    override func setViewController() {
        self.inputNavigateView.isUserInteractionEnabled = true
        self.capsuleTableView.setUp(target: self, cell: CapsuleTableViewCell.self)
        self.inputNavigateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateInputViewController)))
        var currentDateString = Date().dateToString()
        currentDateString.insert("\n", at: currentDateString.index(currentDateString.startIndex, offsetBy: 6)) //currentDateString.insert("\n", at:  )
        self.dateLabel.text = currentDateString
    }
    
    func setUpTableView() {
        self.capsuleTableView.tableFooterView = UIView()
        self.capsuleTableView.separatorStyle = .singleLine
        self.capsuleTableView.separatorColor = UIColor(red: 1/255, green: 117/255, blue: 152/255, alpha: 1)
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.capsuleTableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.capsuleTableView.tableHeaderView = line
        line.backgroundColor = self.capsuleTableView.separatorColor
    }
    
    @objc func navigateInputViewController() {
        let nextVC: InputViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: InputViewController.reuseIdentifier) as! InputViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
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
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y * 2
        print(offset)
        UIView.animate(withDuration: 0.001) {
            if offset <= 60 {
                self.topConstraint.constant =  30 - offset
                self.bottomConstraint.constant = 80 - offset
                self.dateLabel.alpha = (60 - offset) / 60
            }
            else if offset > 60 {
                self.topConstraint.constant = -30
                self.bottomConstraint.constant = 20
                self.dateLabel.alpha = 0
            }
            self.view.layoutIfNeeded()
        }
        
    }
}
