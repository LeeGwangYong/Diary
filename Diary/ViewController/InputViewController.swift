//
//  InputViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class InputViewController: ViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var dateString: String?
    var keyboardDismissGesture: UITapGestureRecognizer?
    let limitTextCount = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setKeyboardSetting()
    }
    
    override func setViewController() {
        let registerBarButton = UIBarButtonItem(title: "담아두기", style: UIBarButtonItemStyle.done, target: self, action: #selector(selectKeepDay))
        registerBarButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .disabled)
        self.navigationItem.rightBarButtonItem = registerBarButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        if let dateString = dateString  {
            self.dateLabel.text = dateString
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
