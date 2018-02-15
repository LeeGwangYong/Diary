//
//  SignUpEmailViewController.swift
//  Diary
//
//  Created by 박수현 on 15/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

class SignUpEmailViewController: UIViewController {

    @IBOutlet weak var pwAlertLabel: UILabel!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        pwAlertLabel.isHidden = true
        let text = "이메일과 비밀번호를\n알려주세요"
        textLabel.text = text
        //textLabel.font = UIFont(name: "SpoqaHanSans-Bold", size: 28)
        textLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        pwField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        drawCompleteButton()
        self.emailField.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
        self.pwField.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
    }

    @objc func drawCompleteButton(){
        let completeButton: UIButton!
        completeButton = UIButton(type: .custom)
        completeButton.frame = CGRect(x: 232, y: 352, width: 127, height: 42)
        //completeButton.titleLabel!.font =  UIFont(name: "SpoqaHanSans-Regular", size: 16)
        completeButton.layer.cornerRadius = 4
        completeButton.setTitle("완료", for: .normal)
        
        if (emailField.text?.isEmpty)! || (pwField.text?.isEmpty)! {
            completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
            completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        } else {
            if validateEmail(enteredEmail: emailField.text!) {
                if pwField.text!.count >= 8 {
                    pwAlertLabel.isHidden = true
                    pwField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
                    completeButton.frame = CGRect(x: 233, y: 352.5, width: 125.5, height: 40.5)
                    completeButton.backgroundColor = UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0)
                    completeButton.addTarget(self, action: #selector(compelteButtonClicked), for: .touchUpInside)
                    
                }
                else {
                    pwAlertLabel.isHidden = false
                    pwField.addBorderBottom(height: 1.0, color: UIColor.red)
                    completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
                    completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
                }
                emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
            } else {
                if pwField.text!.count >= 8 {
                    pwAlertLabel.isHidden = true
                    pwField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
                }
                else {
                    pwAlertLabel.isHidden = false
                    pwField.addBorderBottom(height: 1.0, color: UIColor.red)
                    
                }
                emailField.addBorderBottom(height: 1.0, color: UIColor.red)
                completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
                completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
            }
           // nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
            
        }
        self.view.addSubview(completeButton)
    }
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    @objc func compelteButtonClicked() {
        performSegue(withIdentifier: "AuthCode", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
