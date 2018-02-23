//
//  LoginViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageBottomView: UIView!
    @IBOutlet weak var timaryLogoLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customLoginButton()
        self.imageBottomView.createGradientLayer()
        self.timaryLogoLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        self.imageBottomView.makeRoundedView(corners: [.allCorners], radius: 5)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedString = NSMutableAttributedString(string: "기억의 타임캡슐\n타이머리")
        logoLabel.attributedText = attributedString
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.heavy), range: NSRange(location: 8, length: 5))
        logoLabel.attributedText = attributedString
        self.passwordField.isSecureTextEntry = true
        setPlaceholderColor()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func setPlaceholderColor() {
        emailField.attributedPlaceholder = NSAttributedString(string: "이메일 주소",
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "8자리 이상 입력해주세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0)])
        
        paddingTextField(textField: self.emailField)
        paddingTextField(textField: self.passwordField)
    }
    
    func paddingTextField(textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.always
        textField.rightView = paddingView
        textField.rightViewMode = UITextFieldViewMode.always
    }
    
    func customLoginButton() {
        loginButton.createGradientLayer()
        loginButton.makeRoundedView(corners: [.bottomLeft, .bottomRight])
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginButtonClicked(sender: UIButton){
        let param: Parameters = [
            "email" : emailField.text!,
            "password" : passwordField.text!
        ]
        
        SignService.getSignData(url: "signin", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                print(dataJSON)
                if dataJSON["code"] == "0000" {
                    self.performSegue(withIdentifier: "MainSegue", sender: self)
                }
            case .Failure(let failureCode):
                print("Sign In Failure : \(failureCode)")
                
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
