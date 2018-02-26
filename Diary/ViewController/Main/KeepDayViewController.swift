//
//  KeeDayViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 16..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import Hero


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
    
    var selectedDate: Date? {
        didSet {
            if let dateString = selectedDate?.dateToStringYMD() {
                let attributedString = NSMutableAttributedString(string: "\(dateString)까지\n기억을 담아둡니다")
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold), range: NSRange(location: 0, length: dateString.count))
                self.selectedDateLabel.attributedText = attributedString
            }
            fadeView(view: self.selectedDateLabel, hidden: false)
            fadeView(view: self.memorizeButton, hidden: false)
            
        }
    }
    
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var memorizeButton: UIButton!
    var delegate: InputViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        memorizeButton.createGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.displayLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
    }
    
    override func setViewController() {
        self.selectedDateLabel.isHidden = true
        self.memorizeButton.isHidden = true
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
    
    func fadeView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    @IBAction func touchUpRegisterCapsule(_ sender: UIButton) {
        fetchRegisterCapsule()
    }
    
    func fetchRegisterCapsule() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let userIdx = Token.getUserIndex(), let contents = self.delegate?.textView.text, let selectedDate = self.selectedDate {
            let parameters: [String : Any] = ["userIdx" : userIdx,
                                              "contents" : contents,
                                              "openDate" : formatter.string(from: selectedDate)]
            CapsuleService.request(url: "write", parameter: parameters, completion: { (result) in
                switch result {
                case .Success(let value):
                    let dataJSON = JSON(value)
                    print(dataJSON)
                    if let code = dataJSON["code"].string, code == "0009" {
                        self.view.makeToast(dataJSON["errmsg"].stringValue)
                    }
                    else {
                        let completionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CompletionViewController.reuseIdentifier) as! CompletionViewController
                        if let selectedDate = self.selectedDate?.dateToStringYMD() {
                            completionVC.titleString = "\(selectedDate)에\n기억을 꺼냅니다"
                        }
                        completionVC.delegate = self
                        
                        self.present(completionVC, animated: true, completion: nil)
                    }
                case .Failure(let failureCode) :
                    print(failureCode)
                }
            })
        }
    }
    
    override func customSegue() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension KeepDayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DivisionOfTheYear.allDescription.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeepDayCell.reuseIdentifier, for: indexPath) as! KeepDayCell
        if 1 <= indexPath.row && indexPath.row <= 4  {
            cell.titleLabel.text = "다음 \(DivisionOfTheYear.allDescription[indexPath.row])"
        }
        else if indexPath.row == 5 {
            cell.titleLabel.text = "내년 \(DivisionOfTheYear.allDescription[indexPath.row])"
        }
        else {
            cell.titleLabel.text = DivisionOfTheYear.allDescription[indexPath.row]
        }
        cell.reload()
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? KeepDayCell {
            cell.reload()
        }
        let selectedDivision = DivisionOfTheYear.allCases[indexPath.row]
        if let selectedDate = selectedDivision.date {
            
            self.selectedDate = selectedDate
            let text = self.selectedDateLabel.attributedText
            var attributeString = NSMutableAttributedString(string: "\(selectedDivision.description) ")
            attributeString.append(text!)
            self.selectedDateLabel.attributedText = attributeString
        }
        else {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CalendarViewController.reuseIdentifier) as! CalendarViewController
            nextVC.delegate = self
            self.navigationController?.present(nextVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? KeepDayCell {
            cell.reload()
        }
    }
    
}
