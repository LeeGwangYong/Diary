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

class ResetPasswordViewController: ViewController, UITextFieldDelegate {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var completeButton: CustomButton!
    @IBOutlet weak var emailField: UITextField!
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTextLabel()
        emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        self.view.layoutIfNeeded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setCompleteButton()
        self.emailField.delegate = self
        self.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        self.emailField.addTarget(self, action: #selector(setCompleteButton), for: UIControlEvents.editingChanged)
        self.view.bringSubview(toFront: self.indicatorView)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    func setTextLabel() {
        let text = "비밀번호를\n잊으셨나요?"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    @objc func setCompleteButton(){
        if emailField.text!.isEmpty {
            completeButton.isEnabled = false
        } else {
            if validateEmail(enteredEmail: emailField.text!) {
                completeButton.isEnabled = true
            } else {
                completeButton.isEnabled = false
            }
        }
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
        self.indicatorView.startAnimating()
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
                    self.indicatorView.stopAnimating()
                    UserDefaults.standard.synchronize()
                    let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ResetPasswordLoginViewController.reuseIdentifier)
                    self.present(nextVC, animated: true, completion: nil)
                } else {
                    self.indicatorView.stopAnimating()
                    self.view.makeToast(dataJSON["errmsg"].stringValue)
                }
                
            case .Failure(let failureCode):
                print("Password Reset Email Failure : \(failureCode)")
                
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField != nil {
            completeButtonClicked()
        }
        return true
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
