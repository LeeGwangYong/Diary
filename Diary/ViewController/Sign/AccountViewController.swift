//
//  AccountViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class AccountViewController: UIViewController {
    @IBOutlet weak var emailAlertLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordAlertLabel: UILabel!

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var completeButton: UIButton!
    var nickname = UserDefaults.standard.string(forKey: "nickname")!
    var isCalling = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTextLabel()
        emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        passwordField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTextLabel()
        emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        passwordField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        self.view.layoutIfNeeded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordAlertLabel.isHidden = true
        self.emailAlertLabel.isHidden = true
        completeButton.layer.cornerRadius = 4
        completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
        completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        
        self.emailField.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
        self.passwordField.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.view.bringSubview(toFront: self.indicatorView)
    }
    func setTextLabel() {
        let text = "이메일과 비밀번호를\n알려주세요"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    @objc func drawCompleteButton() {
        if (emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
            completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
            completeButton.isEnabled = false
        } else {
            if validateEmail(enteredEmail: emailField.text!) {
                if passwordField.text!.count >= 8   {
                    passwordAlertLabel.isHidden = true
                    completeButton.setTitleColor(UIColor.white, for: .normal)
                    completeButton.backgroundColor = UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0)
                    completeButton.addTarget(self, action: #selector(compelteButtonClicked), for: .touchUpInside)
                    completeButton.isEnabled = true
                } else {
                    completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
                    completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
                    passwordAlertLabel.isHidden = false
                    completeButton.isEnabled = false
                }
            } else {
                if passwordField.text!.count >= 8   {
                    passwordAlertLabel.isHidden = true
                    completeButton.isEnabled = false
                    completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
                    completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
                } else {
                    completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
                    completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
                    passwordAlertLabel.isHidden = false
                }
            }
        }
        self.view.addSubview(completeButton)
    }
    
    @objc func signUp() {
        self.indicatorView.startAnimating()
        let param: Parameters = [
            "email" : emailField.text!,
            "password" : passwordField.text!,
            "nickname" : nickname
        ]
        
        SignService.getSignData(url: "signup", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                
                if let code = dataJSON["code"].string, code == "0000" {
                    self.indicatorView.stopAnimating()
                    let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: VerifyEmailViewController.reuseIdentifier) as! VerifyEmailViewController
                    nextVC.email = self.emailField.text
                    nextVC.password = self.passwordField.text
                    nextVC.userIdx = dataJSON["data"]["idx"].int
                    self.navigationController?.pushViewController(nextVC, animated: true)
                } else if let code = dataJSON["code"].string, code == "0001" {
                    self.indicatorView.stopAnimating()
                    self.emailAlertLabel.isHidden = false
                }
            case .Failure(let failureCode):
                print("Sign Up Failure : \(failureCode)")
                
            }
        }
        
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    @objc func compelteButtonClicked() {
        signUp()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
