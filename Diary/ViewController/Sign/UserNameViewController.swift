//
//  UserNameViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit

class UserNameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var ToSLabel: UILabel!
    @IBOutlet weak var userNameField: UITextField!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.userNameField.delegate = self
        setLabel()
        userNameField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setToSLabel()
        self.view.addSubview(ToSLabel)
        
        self.nextButton.isEnabled = false
        self.userNameField.addTarget(self, action: #selector(setNextButton), for: UIControlEvents.editingChanged)
        self.nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.ToSLabel.isUserInteractionEnabled = true
        self.ToSLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToTerms)))
    }
    
    @objc func setNextButton() {
        if userNameField.text!.isEmpty {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    func setLabel(){
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
    }
    
    @objc func nextButtonClicked() {
        UserDefaults.standard.set(userNameField.text, forKey: "nickname")
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AccountViewController.reuseIdentifier)
        self.navigationController?.pushViewController(nextVC, animated: true)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userNameField != nil {
            nextButtonClicked()
        }
        return true
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func navigateToTerms() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TermsOfServiceViewController.reuseIdentifier)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}
