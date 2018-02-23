//
//  LoginViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var outLine: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoLineView = UIView(frame: CGRect(x: view.center.x - 21, y: 127, width: 42, height: 5))
        logoLineView.layer.borderColor = UIColor(red: 168/255, green: 128/255, blue:177/255, alpha: 1.0).cgColor
        logoLineView.createLineGradientLayer()
        self.view.addSubview(logoLineView)
        
        let attributedString = NSMutableAttributedString(string: "기억의 타임캡슐\n타이머리")
        logoLabel.attributedText = attributedString
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.heavy), range: NSRange(location: 8, length: 5))
        logoLabel.attributedText = attributedString
        
        self.view.addSubview(logoLabel)
        
        
        let lineView = UIView(frame: CGRect(x: 0, y: 56, width: stackView.bounds.width, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 168/255, green: 128/255, blue:177/255, alpha: 0.5).cgColor
        self.stackView.addSubview(lineView)
        
        customLoginButton()
        setPlaceholderColor()
        setOutLine()
        
    }
    
    
    func setOutLine() {
        outLine.layer.borderWidth = 1
        outLine.layer.borderColor = UIColor(red: 177/255, green: 177/255, blue:177/255, alpha: 1.0).cgColor
        outLine.layer.cornerRadius = 4.0
    }
    
    func setPlaceholderColor() {
        emailField.attributedPlaceholder = NSAttributedString(string: "이메일 주소",
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "8자리 이상 입력해주세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0)])
    }
    
    func customLoginButton() {
        loginButton.createGradientLayer()
        loginButton.roundedButton()
        loginButtonView.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginButtonClicked(sender: UIButton){
        /*
         let param: Parameters = [
         "email" : self.emailField,
         "password" : self.passwordField
         ]
         SignService.getSignData(url: "api/signup", parameter: param) { (result) in
         switch result {
         case .Success(let response):
         guard let data = response as? Data else {return}
         let dataJSON = JSON(data)
         print(dataJSON)
         case .Failure(let failureCode):
         print("Sign In Failure : \(failureCode)")
         
         }
         }
         */
        print("dddddd")
    }
    
}
