//
//  UserNameViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit

class UserNameViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var ToSLabel: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLabel()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setToSLabel()
        self.view.addSubview(ToSLabel)
        setNextButton()
        self.userNameField.addTarget(self, action: #selector(setNextButton), for: UIControlEvents.editingChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func setNextButton(){
        nextButton.layer.cornerRadius = 4
        if userNameField.text!.isEmpty {
            nextButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
            nextButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        } else {
            nextButton.backgroundColor = UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0)
            nextButton.setTitleColor(UIColor.white, for: .normal)
            
            nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
            
        }
        self.view.addSubview(nextButton)
    }
    func setLabel(){
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
    }
    
    @objc func nextButtonClicked() {
        UserDefaults.standard.set(userNameField.text, forKey: "nickname")
        performSegue(withIdentifier: "AccountSegue", sender: self)
    }
    func setToSLabel() {
        let attributedString = NSMutableAttributedString(string: "서비스 이용약관과 정책에\n동의하고 회원가입을 진행합니다")
        ToSLabel.attributedText = attributedString
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.heavy), range: NSRange(location: 0, length: 8))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.heavy), range: NSRange(location: 10, length: 2))
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: 8))
        attributedString.addAttribute(NSAttributedStringKey.underlineColor, value: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), range: NSRange(location: 0, length: 8))
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 10, length: 2))
        attributedString.addAttribute(NSAttributedStringKey.underlineColor, value: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0), range: NSRange(location: 10, length: 2))
        
        ToSLabel.attributedText = attributedString
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
