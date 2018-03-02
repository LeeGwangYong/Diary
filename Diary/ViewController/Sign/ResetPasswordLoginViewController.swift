//
//  ResetPasswordLoginViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class ResetPasswordLoginViewController: UIViewController {
 
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var emailResendButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTextLabel()
        customLoginButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailResendButton.addTarget(self, action: #selector(resendPasswordResetEmail), for: .touchUpInside)
    }
    func setTextLabel() {
        let text = "이메일로\n임시 비밀번호를 보냈습니다"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    @objc func resendPasswordResetEmail() {
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
                    self.view.makeToast("새로운 비밀번호를 재전송하였습니다.")
                } else {
                    self.view.makeToast(dataJSON["errmsg"].stringValue)
                }
            case .Failure(let failureCode):
                print("Password Reset Email Failure : \(failureCode)")
                
            }
        }
        
    }
    func customLoginButton() {
        loginButton.createGradientLayer()
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
    }
    @objc func loginButtonClicked() {
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LoginViewController.reuseIdentifier)
        self.present(nextVC, animated: true, completion: nil)
    }

    
}
