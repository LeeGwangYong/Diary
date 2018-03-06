//
//  ExistingPasswordViewController.swift
//  Diary
//
//  Created by 박수현 on 26/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ExistingPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var completeButton: CustomButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var passwordAlertLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLabel()
        self.view.layoutIfNeeded()
        passwordField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNextButton()
        self.passwordField.delegate = self
        self.passwordField.addTarget(self, action: #selector(setNextButton), for: UIControlEvents.editingChanged)
        self.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.view.bringSubview(toFront: indicatorView)
    }
    @objc func setNextButton(){
        if passwordField.text!.isEmpty {
            passwordAlertLabel.isHidden = true
            completeButton.isEnabled = false
        } else {
            if passwordField.text!.count < 8 {
                passwordAlertLabel.text = "8자 이상 입력해주세요"
                passwordAlertLabel.isHidden = false
                completeButton.isEnabled = false
            } else {
                passwordAlertLabel.isHidden = true
                completeButton.isEnabled = true
            }
        }
    }
    func setLabel(){
        let text = "기존 비밀번호를\n입력해주세요"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
    }
    func updatePassword() {
        self.indicatorView.startAnimating()
     
        let param: Parameters = [
            "idx" : UserDefaults.standard.string(forKey: "userIdx")!,
            "password" : passwordField.text!
        ]
        
        SignService.getSignData(url: "confirmpassword", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                print(dataJSON)
                if dataJSON["code"] == "0000" {
                    self.indicatorView.stopAnimating()
                    self.passwordAlertLabel.isHidden = true
                    let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: UpdatePasswordViewController.reuseIdentifier)
                    self.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                else {
                    self.indicatorView.stopAnimating()
                    self.passwordAlertLabel.text = "비밀번호가 일치하지 않습니다."
                    self.passwordAlertLabel.isHidden = false
                }
            case .Failure(let failureCode):
                print("Resend Email In Failure : \(failureCode)")
            }
        }
    }
    @objc func completeButtonClicked() {
        updatePassword()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if passwordField.text!.count >= 8 {
            completeButtonClicked()
        }
        return true
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
