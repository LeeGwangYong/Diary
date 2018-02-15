//
//  LoginViewController.swift
//  Diary
//
//  Created by 박수현 on 17/01/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LoginViewController: UIViewController {
    var loginButton: UIButton!
    var fieldEmail: UITextField!
    var fieldPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoLineView = UIView(frame: CGRect(x: 167, y: 127, width: 42, height: 5))
        logoLineView.layer.borderColor = UIColor(red: 168/255, green: 128/255, blue:177/255, alpha: 1.0).cgColor
        logoLineView.createLineGradientLayer()
        self.view.addSubview(logoLineView)
    
        let attributedString = NSMutableAttributedString(string: "기억의 타임캡슐\n타이머리")
        logoLabel.attributedText = attributedString
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.heavy), range: NSRange(location: 8, length: 5))
        logoLabel.attributedText = attributedString
        
        self.view.addSubview(logoLabel)
        self.setTextField()
        self.drawLoginButton()
        
        let lineView = UIView(frame: CGRect(x: 32, y: 332, width: 311, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 168/255, green: 128/255, blue:177/255, alpha: 0.5).cgColor
        self.view.addSubview(lineView)

        let stackView = UIStackView(arrangedSubviews: [fieldEmail,fieldPassword,loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
       
        loginBackground(backgroundView, to: stackView)
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -225).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: view.frame.height/4).isActive = true
    }

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 177/255, green: 177/255, blue:177/255, alpha: 1.0).cgColor
        view.layer.cornerRadius = 4.0
        return view
    }()

    func loginBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.setField(to: stackView)
    }
    func setPlaceholder(textField: UITextField) -> NSAttributedString {
        var placeholderString: String = ""
        switch textField {
            case fieldEmail :
                placeholderString = "이메일 주소"
            case fieldPassword :
                placeholderString = "8자 이상 입력해주세요"
            default :
                ()
        }
        let placeholder = NSAttributedString(string: placeholderString, attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0)])
        return placeholder
    }
    func setTextField() {
        fieldEmail = UITextField(frame: CGRect(x: 0, y: 0, width: 311, height: 56))
        fieldEmail.autocapitalizationType = .none
        fieldEmail.font = UIFont.systemFont(ofSize: 14)
        fieldEmail.attributedPlaceholder = setPlaceholder(textField: fieldEmail)
        fieldEmail.setLeftPaddingPoints(16)
        
        fieldPassword = UITextField(frame: CGRect(x: 0, y: 0, width: 311, height: 56))
        fieldPassword.font = UIFont.systemFont(ofSize: 14)
        fieldPassword.isSecureTextEntry = true
        fieldPassword.attributedPlaceholder = setPlaceholder(textField: fieldPassword)
        fieldPassword.setLeftPaddingPoints(16)
    }
    func drawLoginButton() {
        loginButton = UIButton(type: .custom)
        loginButton.frame = CGRect(x: 0, y: 0, width: 311, height: 62)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.tintColor = UIColor.white
        loginButton.setTitle("로그인", for: .normal)
        //loginButton.titleLabel!.font =  UIFont(name: "SpoqaHanSans-Bold", size: 16)
        loginButton.createGradientLayer()
        loginButton.roundedButton()
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginButtonClicked(sender: UIButton){
       /*
        let param: Parameters = [
            "email" : self.fieldEmail,
            "password" : self.fieldPassword,
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
        }*/
       print("dddddd")
    }
 
}



