//
//  ResetPasswordViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidAppear(_ animated: Bool) {
        setTextLabel()
        emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setCompleteButton()
        self.emailField.addTarget(self, action: #selector(setCompleteButton), for: UIControlEvents.editingChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
    }
    func setTextLabel() {
        let text = "비밀번호를\n잊으셨나요?"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    @objc func setCompleteButton(){
        completeButton.layer.cornerRadius = 4
        if emailField.text!.isEmpty {
            completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
            completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        } else {
            if validateEmail(enteredEmail: emailField.text!) {
                completeButton.backgroundColor = UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0)
                completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
            }
        }
        self.view.addSubview(completeButton)
    }
    @objc func completeButtonClicked() {
        UserDefaults.standard.set(emailField.text, forKey: "email")
        passwordResetEmail()
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    func passwordResetEmail(){
        let param: Parameters = [
            "email" : UserDefaults.standard.string(forKey: "email")!
        ]
        
        SignService.getSignData(url: "passwordresetemail", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                print(dataJSON)
                if dataJSON["code"] == "0000" {
                    self.view.makeToast("새로운 비밀번호를 보냈습니다.", duration: 1, position: .center, title: nil, image: nil, style: ToastStyle.init(), completion: { (bool) in
                        if self.emailField.text != nil {
                            self.performSegue(withIdentifier: "PasswordEmailSegue", sender: self)
                        }
                        else {
                    
                        }
                    })
                }
                
            case .Failure(let failureCode):
                print("Password Reset Email Failure : \(failureCode)")
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
}
