//
//  MainViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 17..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class MainViewController: ViewController {
    //MARK -: Property
    @IBOutlet weak var blinkingView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var inputNavigateView: UIView!
    @IBOutlet weak var capsuleTableView: UITableView!
    @IBOutlet weak var capsuleCountLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private var token: NotificationToken!
    var capsules = Capsule.realm?.objects(Capsule.self).sorted(byKeyPath: "idx", ascending: true)
    
    //MARK -: Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewController()
        self.setUpTableView()
        self.fetchCapsuleList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transparentNavigationBar()
        self.blinkingView.alpha = 0.2
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.blinkingView.alpha = 1.0}, completion: nil)
//        self.inputNavigateView.createGradientLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputNavigateView.createGradientLayer()
    }
    
    override func setViewController() {
        self.inputNavigateView.isUserInteractionEnabled = true
        self.capsuleTableView.setUp(target: self, cell: CapsuleTableViewCell.self)
        self.inputNavigateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateInputViewController)))
        var currentDateString = "\(Date().dateToStringYMD())의 기억"
        currentDateString.insert("\n", at: currentDateString.index(currentDateString.startIndex, offsetBy: 6))
        self.dateLabel.text = currentDateString
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func setUpTableView() {
        self.capsuleTableView.tableFooterView = UIView()
        self.capsuleTableView.separatorStyle = .singleLine
        self.capsuleTableView.separatorColor = UIColor(red: 1/255, green: 117/255, blue: 152/255, alpha: 1)
        
        token = capsules?.observe({ (change) in
            self.capsuleTableView.reloadData()
            let countString = "\(self.capsules?.count ?? 0) 개"
            let attributedString = NSMutableAttributedString(string: "\(countString)의 기억이\n타임캡슐에 담겨있습니다")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold ), range: NSRange(location: 0, length: countString.count))
            self.capsuleCountLabel.attributedText = attributedString
        })
    }
    
    func fetchCapsuleList() {
        CapsuleService.getListData(url: "list", parameter: Token.getUserIndex()) { (result) in
            switch result {
            case .Success(let value) :
                print(value.code)
                if let capsules = value.capsule {
                    for capsule in capsules {
                        Capsule.write(capsule, state: RealmState.add)
                    }
                }
            case .Failure(let failureCode) :
                print(failureCode)
            }
        }
    }
    
    @objc func navigateInputViewController() {
        let nextVC: InputViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: InputViewController.reuseIdentifier) as! InputViewController
        nextVC.dateString = self.dateLabel.text
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

//MARK -: Extension
//MARK : TableViewDelegate, TabelViewDatasource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return capsules?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CapsuleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        if let capsule = self.capsules?[indexPath.row] {
            cell.update(insertDate: capsule.insertDate,
                        openDate: capsule.openDate,
                        content: capsule.contents)
        }
        return cell
    }

    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.y * 2
//        print(offset)
//        UIView.animate(withDuration: 0.001) {
//            if offset <= 60 {
//                self.topConstraint.constant =  30 - offset
//                self.bottomConstraint.constant = 80 - offset
//                self.dateLabel.alpha = (60 - offset) / 60
//            }
//            else if offset > 60 {
//                self.topConstraint.constant = -30
//                self.bottomConstraint.constant = 20
//                self.dateLabel.alpha = 0
//            }
//            self.view.layoutIfNeeded()
//        }
//        
//    }
}
