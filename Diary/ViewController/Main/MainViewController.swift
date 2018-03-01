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
    func date(hour: Int)-> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let date = Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: Calendar.current.timeZone, year: components.year, month: components.month, day: components.day, hour: hour, minute: 00, second: 00))
        return date!
    }
    var capsules = Capsule.realm?.objects(Capsule.self).sorted(byKeyPath: "openDate", ascending: true)
    
    //MARK -: Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewController()
        self.setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCapsuleList()
        self.transparentNavigationBar()
        self.blinkingView.alpha = 0.2
        self.inputNavigateView.createGradientLayer()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveLinear, .repeat, .autoreverse],
                       animations: {self.blinkingView.alpha = 1.0},
                       completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        switch Date().compare(date(hour: 9)) {
        case .orderedAscending, .orderedSame: // A가 B보다 이르다.
            capsules =  Capsule.realm?.objects(Capsule.self).sorted(byKeyPath: "openDate", ascending: true).filter("openDate >= %@", date(hour: 0))
        case .orderedDescending: // A가 B보다 늦다.
            capsules = Capsule.realm?.objects(Capsule.self).sorted(byKeyPath: "openDate", ascending: true).filter("openDate > %@", date(hour: 9))
        }
        
        self.token = capsules?.observe({ (change) in
            let countString = "\(self.capsules?.count ?? 0) 개"
            let attributedString = NSMutableAttributedString(string: "\(countString)의 기억이\n타임캡슐에 담겨있습니다")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold ), range: NSRange(location: 0, length: countString.count))
            self.capsuleCountLabel.attributedText = attributedString
            self.capsuleTableView.reloadData()
        })
    }
    
    func fetchCapsuleList() {
        if let userIdx = Token.getUserIndex() {
            CapsuleService.getListData(url: "list", parameter: ["userIdx" : userIdx]) { (result) in
                switch result {
                case .Success(let value) :
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
    }
    
    @objc func navigateInputViewController() {
        let nextVC: InputViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: InputViewController.reuseIdentifier) as! InputViewController
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        if let capsule = self.capsules?[indexPath.row] {
            cell.update(insertDate: capsule.insertDate,
                        openDate: capsule.openDate,
                        content: capsule.contents)
        }
        
        if let openDate = capsules?[indexPath.row].openDate {
            switch openDate.compare(date(hour: 9)) {
            case .orderedAscending, .orderedSame :
                cell.gradiantView.isHidden = false
            case .orderedDescending :
                cell.gradiantView.isHidden = true
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let capsule = capsules?[indexPath.row] {
            self.view.makeToast("기억을 \(Date().calculateDDay(to: capsule.openDate))일 후에 꺼낼 수 있습니다")
        }
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
