//
//  SignUpEmailViewController.swift
//  Diary
//
//  Created by 박수현 on 15/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpEmailViewController: UIViewController {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var pwAlertLabel: UILabel!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
 
    var nickname = UserDefaults.standard.string(forKey: "nickname")!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        pwAlertLabel.isHidden = true
        let text = "이메일과 비밀번호를\n알려주세요"
        textLabel.text = text
        textLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
       
        completeButton.layer.cornerRadius = 4
        completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
        completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        pwField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        
        self.emailField.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
        self.pwField.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
    }

   @objc func drawCompleteButton() {
   
        if checkEmailField() {
            if checkPasswordField() {
                completeButton.setTitleColor(UIColor.white, for: .normal)
                completeButton.backgroundColor = UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0)
                UserDefaults.standard.set(self.emailField.text, forKey: "email")
                UserDefaults.standard.set(self.pwField.text, forKey: "password")
                completeButton.addTarget(self, action: #selector(compelteButtonClicked), for: .touchUpInside)
                //completeButton.addTarget(self, action: #selector(sendEmailAuthCode), for: .touchUpInside)
            }
        } else {
            if checkPasswordField() {
            }
            completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
            completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        }
        self.view.addSubview(completeButton)
    }
    func checkEmailField() -> Bool {
        if (emailField.text?.isEmpty)! {
            //emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
            return false
        }
        if validateEmail(enteredEmail: emailField.text!) {
            //emailField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
            return true
        } else {
           // emailField.addBorderBottom(height: 1.0, color: UIColor.red)
            return false
        }
        
    }
    func checkPasswordField() -> Bool {
        if (pwField.text?.isEmpty)! {
            //pwField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
            return false
        }
        if pwField.text!.count >= 8  {
            //pwField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
            pwAlertLabel.isHidden = true
            return true
        } else {
            pwAlertLabel.isHidden = false
            //pwField.addBorderBottom(height: 1.0, color: UIColor.red)
            return false
        }
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignedUp" {
            if segue.destination is VerifyEmailViewController {
                if let destinationVC = segue.destination as? VerifyEmailViewController {
                    destinationVC.idx = idx
                }
            }
        }
 
    }
*/
    @objc func signUp() {
        
        let param: Parameters = [
            "email" : emailField.text!,
            "password" : pwField.text!,
            "nickname" : nickname
        ]
        
        SignService.getSignData(url: "api/signup", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                 guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                UserDefaults.standard.set(dataJSON["data"]["idx"].int, forKey: "userIdx")
                if dataJSON["code"] == "0000" {
                    
                    self.performSegue(withIdentifier: "AuthCode", sender: self)
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
    @objc func compelteButtonClicked() {
        signUp()
        //performSegue(withIdentifier: "AuthCode", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
