//
//  KeeDayViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 16..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class KeepDayCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutIfNeeded() {
        super.layoutSubviews()
        reload()
    }
    func reload() {
        if isSelected {
            self.contentView.backgroundColor = UIColor(red:  168/255, green: 128/255, blue: 177/255, alpha: 1)
            self.titleLabel.textColor = UIColor.white
            self.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        } else {
            self.contentView.backgroundColor = UIColor.clear
            self.titleLabel.textColor = UIColor.black
            self.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        }
    }
}

class KeepDayViewController: ViewController {
    let days = ["달력에서 직접 선택", "다음 봄이 시작되는 날", "올해의 마지막 날", "내년 첫 날", "아무때나"]
    var selectedDate: Date? {
        didSet {
            if let dateString = selectedDate?.dateToStringYMD() {
                let attributedString = NSMutableAttributedString(string: "\(dateString)까지\n기억을 담아둡니다")
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold), range: NSRange(location: 0, length: dateString.count))
                self.selectedDateLabel.attributedText = attributedString
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var memorizeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memorizeButton.createGradientLayer()
    }
    
    override func setViewController() {
       
    }
    
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1)
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
    }
}

extension KeepDayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeepDayCell.reuseIdentifier, for: indexPath) as! KeepDayCell
        cell.titleLabel.text = days[indexPath.row]
        cell.reload()
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? KeepDayCell {
            cell.reload()
        }
        switch indexPath.row {
        case 0:
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CalendarViewController.reuseIdentifier) as! CalendarViewController
            nextVC.delegate = self
            self.navigationController?.present(nextVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? KeepDayCell {
            cell.reload()
        }
    }
    
}
