//
//  InputViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import SwiftyJSON

class InputViewController: ViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var displayDate: Date? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년\nM월 dd일의 기억"
            formatter.locale = Calendar.current.locale
            formatter.timeZone = Calendar.current.timeZone
            if let displayDate = self.displayDate {
                self.dateLabel.text = formatter.string(from: displayDate)
            }
        }
    }
    var idx: Int?
    
    var keyboardDismissGesture: UITapGestureRecognizer?
    let limitTextCount = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setKeyboardSetting()
    }
    
    override func setViewController() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.displayDate = Date()
        
        if let idx = self.idx {
            self.textView.isEditable = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            let registerBarButton = UIBarButtonItem(title: "삭제", style: UIBarButtonItemStyle.done, target: self, action: #selector(deleteCapsule(_:)))
            registerBarButton.tag = idx
            self.navigationItem.rightBarButtonItem = registerBarButton
            fetchDetail(idx: idx)
        }
        else {
            self.textView.isEditable = true
            let registerBarButton = UIBarButtonItem(title: "담아두기", style: UIBarButtonItemStyle.done, target: self, action: #selector(selectKeepDay))
            registerBarButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .disabled)
            self.navigationItem.rightBarButtonItem = registerBarButton
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        self.textView.placeholder = "오늘은 어떤 기억을 담아둘까?"
        self.textView.tintColor = UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1)
        self.dateLabel.isUserInteractionEnabled = true
        self.textView.delegate = self
    }

    @objc func selectKeepDay() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: KeepDayViewController.reuseIdentifier) as! KeepDayViewController
        nextVC.delegate = self
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func deleteCapsule(_ sender: UIBarButtonItem) {
        print(sender.tag)
        let alertVC = UIAlertController(title: "기억 지우기", message: "기억을 지우면 다시 되돌릴 수 없습니다. 기억을 지우시겠습니까?", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "지우기", style: .destructive) { (alertAction) in
            self.fetchDeleteCapsule(idx: sender.tag)
        }
        alertVC.addAction(cancleAction)
        alertVC.addAction(deleteAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func fetchDetail(idx: Int) {
        if let userIdx = Token.getUserIndex() {
            let parameters = ["userIdx" : userIdx,
                              "contentsIdx" : idx]
            CapsuleService.request(url: "read", parameter: parameters, completion: { (result) in
                switch result {
                case .Success(let value):
                    let dataJSON = JSON(value)
                    print(dataJSON)
                    if let code = dataJSON["code"].string, code == "0009" {
                        self.view.makeToast(dataJSON["errmsg"].stringValue)
                    }
                    else if let code = dataJSON["code"].string, code == "0000"{
                        self.textView.text = dataJSON["data"]["contents"].stringValue
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatter.locale = Calendar.current.locale
                        formatter.timeZone = Calendar.current.timeZone
                        self.displayDate = formatter.date(from: dataJSON["data"]["insert_date"].stringValue)
                    }
                case .Failure(let failureCode) :
                    print(failureCode)
                }
            })
        }
    }
    
    func fetchDeleteCapsule(idx: Int) {
        if let userIdx = Token.getUserIndex() {
            let parameters = ["userIdx" : userIdx,
                              "contentsIdx" : idx]
            CapsuleService.request(url: "delete", parameter: parameters, completion: { (result) in
                switch result {
                case .Success(let value):
                    let dataJSON = JSON(value)
                    print(dataJSON)
                    if let code = dataJSON["code"].string, code == "0009" {
                        self.view.makeToast(dataJSON["errmsg"].stringValue)
                    }
                    else if let code = dataJSON["code"].string, code == "0000"{
                        if let capsule = Capsule.realm?.objects(Capsule.self).filter("idx == %@", idx) {
                            Capsule.write(capsule, state: .remove)
                        }
                        let completionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CompletionViewController.reuseIdentifier) as! CompletionViewController
                        completionVC.delegate = self
                        completionVC.titleString = "\(self.dateLabel.text!)을\n지웠습니다"
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

extension InputViewController {
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.kyeboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.kyeboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func kyeboardWillShow(_ notification: Notification)
    {
        if let keyboadSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            self.adjustKeyboardDismissTapGesture(isKeyboardVisible: true)
            self.textViewBottomConstraint.constant = keyboadSize.height + 32
            
            if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval{
                UIView.animate(withDuration: animationDuration, animations: { self.view.layoutIfNeeded()})
            }
            self.view.layoutIfNeeded()
        }
    }
    @objc func kyeboardWillHide(_ notification: Notification)
    {
        if (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil
        {
            self.textViewBottomConstraint.constant = 32
            
            if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval{
                UIView.animate(withDuration: animationDuration, animations: { self.view.layoutIfNeeded()})
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func adjustKeyboardDismissTapGesture(isKeyboardVisible: Bool){
        if isKeyboardVisible{
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
                self.view.addGestureRecognizer(keyboardDismissGesture!)
            }
        }
        else{
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}


extension InputViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count <= limitTextCount {
            self.navigationItem.rightBarButtonItem?.isEnabled = !(newText.count <= 0)
            return true
        }
        return false
    }
    
    
}
