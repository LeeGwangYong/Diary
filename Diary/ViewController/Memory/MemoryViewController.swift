//
//  MemoryViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 24..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import RealmSwift

class MemoryViewController: ViewController {

    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var capsuleTableView: UITableView!
    private var token: NotificationToken!
    var capsules = Capsule.realm?.objects(Capsule.self).sorted(byKeyPath: "openDate", ascending: true)
    func date(hour: Int)-> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let date = Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: Calendar.current.timeZone, year: components.year, month: components.month, day: components.day, hour: hour, minute: 00, second: 00))
        return date!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transparentNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
    }
    
    override func setViewController() {
        self.capsuleTableView.setUp(target: self, cell: CapsuleTableViewCell.self)
        self.capsuleTableView.tableFooterView = UIView()
        self.capsuleTableView.separatorStyle = .singleLine
        self.capsuleTableView.separatorColor = UIColor(red: 1/255, green: 117/255, blue: 152/255, alpha: 1)
        switch Date().compare(date(hour: 9)) {
        case .orderedAscending, .orderedSame: // A가 B보다 이르다.
            capsules =  Capsule.realm?.objects(Capsule.self).sorted(byKeyPath: "openDate", ascending: true).filter("openDate < %@", date(hour: 9))
        case .orderedDescending: // A가 B보다 늦다.
            capsules = Capsule.realm?.objects(Capsule.self).sorted(byKeyPath: "openDate", ascending: true).filter("openDate <= %@", date(hour: 9))
        }
        self.token = capsules?.observe({ (change) in
            let countString = "\(self.capsules?.count ?? 0) 개"
            let attributedString = NSMutableAttributedString(string: "\(countString)의 기억을 꺼냈습니다")
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold ), range: NSRange(location: 0, length: countString.count))
            self.displayLabel.attributedText = attributedString
            self.capsuleTableView.reloadData()
        })
    }

}

extension MemoryViewController: UITableViewDelegate, UITableViewDataSource {
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
                        opened: true,
                        content: capsule.contents)
        }
        cell.gradiantView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: InputViewController.reuseIdentifier) as! InputViewController
        inputVC.idx = capsules?[indexPath.row].idx
        self.navigationController?.pushViewController(inputVC, animated: true)
    }
}
