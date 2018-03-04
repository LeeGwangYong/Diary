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
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    lazy var viewHeight = self.view.frame.height -  self.topLayoutGuide.length - self.bottomLayoutGuide.length
    @IBOutlet weak var parentScrollView: UIScrollView!
    var childScrollView: UIScrollView {
        return capsuleTableView
    }
    var goingUp: Bool?
    var childScrollingDownDueToParent = false
    
    
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.fetchCapsuleList()
        self.transparentNavigationBar()

        self.view.createGradientLayer()
        
        self.tableViewHeightConstraint.constant = viewHeight - (96 + 72)
        self.parentScrollView.contentSize = CGSize(width: self.view.frame.width, height: 200 + 72 + self.tableViewHeightConstraint.constant)
    }
    
    override func setViewController() {
        self.inputNavigateView.isUserInteractionEnabled = true
        self.inputNavigateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateInputViewController)))
        
        self.parentScrollView.delegate = self
        self.parentScrollView.showsVerticalScrollIndicator = false
        self.parentScrollView.bounces = false
        
        self.capsuleTableView.showsVerticalScrollIndicator = false
//        self.capsuleTableView.bounces = false
        self.capsuleTableView.setUp(target: self, cell: CapsuleTableViewCell.self)
        
        var currentDateString = "\(Date().dateToStringYMD())의 기억"
        currentDateString.insert("\n", at: currentDateString.index(currentDateString.startIndex, offsetBy: 6))
        self.dateLabel.text = currentDateString
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.blinkingView.alpha = 0.2
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveLinear, .repeat, .autoreverse],
                       animations: {self.blinkingView.alpha = 1.0},
                       completion: nil)
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
    
    func uiUpdate(value: CGFloat, max: CGFloat) {
        self.dateLabel.alpha = 1 - value / max
        self.stackViewBottomConstraint.constant = 76 - ( value / max * 56 )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // determining whether scrollview is scrolling up or down
        goingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        
        // maximum contentOffset y that parent scrollView can have
        let parentViewMaxContentYOffset = parentScrollView.contentSize.height - parentScrollView.frame.height
        
        switch goingUp! {
            // if scrollView is going upwards
        case true:
            switch scrollView {
            case childScrollView:
                // if parent scroll view is't scrolled maximum (i.e. menu isn't sticked on top yet)
                if parentScrollView.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    // change parent scrollView contentOffset y which is equal to minimum between maximum y offset that parent scrollView can have and sum of parentScrollView's content's y offset and child's y content offset. Because, we don't want parent scrollView go above sticked menu.
                    // Scroll parent scrollview upwards as much as child scrollView is scrolled
                    // Sometimes parent scrollView goes in the middle of screen and stucks there so max is used.
                    let maxValue = max(min(parentScrollView.contentOffset.y + childScrollView.contentOffset.y, parentViewMaxContentYOffset), 0)
                    print("parentScrollView.contentOffset.y \(parentScrollView.contentOffset.y)")
                    print("maxValue \(maxValue)")
                    self.parentScrollView.contentOffset.y = maxValue
                    print("maxValued parentScrollView.contentOffset.y \(parentScrollView.contentOffset.y)\n")
                    
                    if self.parentScrollView.contentOffset.y >= parentViewMaxContentYOffset {
                        UIView.animate(withDuration: 1, animations: {
                            self.dateLabel.alpha = 0
                            self.stackViewBottomConstraint.constant = 20
                        })
                    }
                    
                    else {
                        uiUpdate(value: maxValue, max: parentViewMaxContentYOffset)
                    }
                    
                    // change child scrollView's content's y offset to 0 because we are scrolling parent scrollView instead with same content offset change.
                    childScrollView.contentOffset.y = 0
                }
            case parentScrollView:
                uiUpdate(value: self.parentScrollView.contentOffset.y, max: parentViewMaxContentYOffset)
            default: break
            }
            
            // Scrollview is going downwards
        case false:
            switch scrollView {
            case childScrollView :
                // when child view scrolls down. if childScrollView is scrolled to y offset 0 (child scrollView is completely scrolled down) then scroll parent scrollview instead
                // if childScrollView's content's y offset is less than 0 and parent's content's y offset is greater than 0
                if childScrollView.contentOffset.y < 0 && parentScrollView.contentOffset.y > 0 {
                    // set parent scrollView's content's y offset to be the maximum between 0 and difference of parentScrollView's content's y offset and absolute value of childScrollView's content's y offset
                    // we don't want parent to scroll more that 0 i.e. more downwards so we use max of 0.
                    
                    parentScrollView.contentOffset.y = max(parentScrollView.contentOffset.y - abs(childScrollView.contentOffset.y), 0)
                    uiUpdate(value: self.parentScrollView.contentOffset.y, max: parentViewMaxContentYOffset)
                }
                
                // if downward scrolling view is parent scrollView
            case parentScrollView:
                // if child scrollView's content's y offset is greater than 0. i.e. child is scrolled up and content is hiding up
                // and parent scrollView's content's y offset is less than parentView's maximum y offset
                // i.e. if child view's content is hiding up and parent scrollView is scrolled down than we need to scroll content of childScrollView first
                if childScrollView.contentOffset.y > 0 && parentScrollView.contentOffset.y < parentViewMaxContentYOffset {
                    // set if scrolling is due to parent scrolled
                    childScrollingDownDueToParent = true
                    // assign the scrolled offset of parent to child not exceding the offset 0 for child scroll view
                    childScrollView.contentOffset.y = max(childScrollView.contentOffset.y - (parentViewMaxContentYOffset - parentScrollView.contentOffset.y), 0)

                    // stick parent view to top coz it's scrolled offset is assigned to child
                    parentScrollView.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
                else {
                    uiUpdate(value: self.parentScrollView.contentOffset.y, max: parentViewMaxContentYOffset)
                }
            default: break
            }
        }
    }
}
