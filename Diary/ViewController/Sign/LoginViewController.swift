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
        self.loginButton.isEnabled = false
        let attributedString = NSMutableAttributedString(string: "기억의 타임캡슐\n타이머리")
        logoLabel.attributedText = attributedString
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.heavy), range: NSRange(location: 8, length: 5))
        logoLabel.attributedText = attributedString
        setPlaceholderColor()
        self.emailField.addTarget(self, action: #selector(setLoginButton), for: UIControlEvents.editingChanged)
        self.passwordField.addTarget(self, action: #selector(setLoginButton), for: UIControlEvents.editingChanged)
        self.loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
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
        self.loginButton.setTitleColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0), for: .disabled)
        self.loginButton.setBackgroundImage(UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0).createImageView(size: loginButton.frame.size), for: .disabled)
        self.loginButton.setTitleColor(UIColor.white, for: .normal)
        
        self.loginButton.makeRoundedView(corners: [.bottomLeft, .bottomRight])
        if loginButton.isEnabled == true {
            loginButton.createGradientLayer()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailField:
            if validateEmail(enteredEmail: emailField.text!) {
                self.passwordField.becomeFirstResponder()
                loginButton.isEnabled = false
            }
        case self.passwordField:
            if passwordField.text!.count >= 8 {
                loginButton.isEnabled = true
                self.loginButtonClicked()
            }
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
                        #if DEBUG
                        print(dataJSON)
                            #endif
                        if dataJSON["code"] == "0000" {
                            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CustomTabBarController.reuseIdentifier) as! CustomTabBarController
                            self.present(mainVC, animated: true, completion: nil)
                        }
                    case .Failure(let failureCode):
                        #if DEBUG
                        print("Auto Login Failure : \(failureCode)")
                        #endif
                        
                    }
                }
            }
        }
    }
    @objc func setLoginButton() {
        if (emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            loginButton.isEnabled = false
        } else {
            if validateEmail(enteredEmail: emailField.text!) {
                if passwordField.text!.count >= 8   {
                    loginButton.isEnabled = true
                } else {
                    loginButton.isEnabled = false
                }
            } else {
                if passwordField.text!.count >= 8   {
                    loginButton.isEnabled = false
                } else {
                    loginButton.isEnabled = false
                }
            }
        }
    }
    @objc func loginButtonClicked() {
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
                #if DEBUG
                print(dataJSON)
                    #endif
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
                #if DEBUG
                print("Sign In Failure : \(failureCode)")
                #endif
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
