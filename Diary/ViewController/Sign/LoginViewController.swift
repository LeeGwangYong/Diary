//  LoginViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageBottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        let attributedString = NSMutableAttributedString(string: "기억의 타임캡슐\n타이머리")
        logoLabel.attributedText = attributedString
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.heavy), range: NSRange(location: 8, length: 5))
        logoLabel.attributedText = attributedString
        setPlaceholderColor()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewDidLayoutSubviews() {
        customLoginButton()
        self.imageBottomView.createGradientLayer()
        self.imageBottomView.makeRoundedView(corners: [.allCorners], radius: 5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        autoLogin()
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
        self.loginButton.makeRoundedView(corners: [.bottomLeft, .bottomRight])
        self.loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        self.loginButton.createGradientLayer()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailField:
            
            self.passwordField.becomeFirstResponder()
        case self.passwordField:
            self.loginButtonClicked(sender: self.loginButton)
        default: break
        }
        return true
    }

    func autoLogin() {
        if UserDefaults.standard.string(forKey: "email") != nil {
            if UserDefaults.standard.string(forKey: "password") != nil {
                let param: Parameters = [
                    "email" : UserDefaults.standard.string(forKey: "email") ?? emailField.text!,
                    "password" : UserDefaults.standard.string(forKey: "password") ?? passwordField.text!
                ]
                SignService.getSignData(url: "signin", parameter: param) { (result) in
                    switch result {
                    case .Success(let response):
                        let data = response
                        let dataJSON = JSON(data)
                        print(dataJSON)
                        if dataJSON["code"] == "0000" {
                            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CustomTabBarController.reuseIdentifier) as! CustomTabBarController
                            self.present(mainVC, animated: true, completion: nil)
                        }
                    case .Failure(let failureCode):
                        print("Auto Login Failure : \(failureCode)")
                        
                    }
                }
            }
        }
    }
    
    @objc func loginButtonClicked(sender: UIButton){
        self.dismissKeyboard()
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
                    UserDefaults.standard.set(self.emailField.text, forKey: "email")
                    UserDefaults.standard.set(self.passwordField.text, forKey: "password")
                    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CustomTabBarController.reuseIdentifier) as! CustomTabBarController
                    self.present(mainVC, animated: true, completion: nil)
                    UserDefaults.standard.set(dataJSON["data"]["idx"].intValue, forKey: "userIdx")
                }
                else {
                    self.view.makeToast(dataJSON["errmsg"].stringValue)
                }
            case .Failure(let failureCode):
                print("Sign In Failure : \(failureCode)")
                
            }
        }
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
