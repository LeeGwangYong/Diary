//
//  UpdatePasswordViewController.swift
//  Diary
//
//  Created by 박수현 on 26/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class UpdatePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var completeButton: CustomButton!
    @IBOutlet weak var passwordAlertLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLabel()
        passwordField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        self.view.layoutIfNeeded()
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
        completeButton.layer.cornerRadius = 4
        if passwordField.text!.isEmpty {
            passwordAlertLabel.isHidden = true
            completeButton.isEnabled = false
        } else {
            if passwordField.text!.count < 8 {
                passwordAlertLabel.isHidden = false
                completeButton.isEnabled = false
            } else {
                passwordAlertLabel.isHidden = true
                completeButton.isEnabled = true
            }
        }
    }
    func setLabel(){
        let text = "새로운 비밀번호를\n입력해주세요"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
    }
    
    @objc func completeButtonClicked() {
        UserDefaults.standard.set(passwordField.text, forKey: "password")
        updatePassword()
    }
    func updatePassword() {
        self.indicatorView.startAnimating()
        let param: Parameters = [
            "idx" : UserDefaults.standard.string(forKey: "userIdx"),
            "password" : UserDefaults.standard.string(forKey: "password")!
        ]
        SignService.getSignData(url: "updatepassword", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                #if DEBUG
                print(dataJSON)
                    #endif
                if dataJSON["code"] == "0000" {
                    self.indicatorView.stopAnimating()
                    let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ConfirmPasswordViewController.reuseIdentifier)
                    self.present(nextVC, animated: true, completion: nil)
                } else if dataJSON["code"] == "0013"{
                    self.indicatorView.stopAnimating()
                    self.view.makeToast("비밀번호 업데이트 오류입니다.")
                }
            case .Failure(let failureCode):
                #if DEBUG
                print("Resend Email In Failure : \(failureCode)")
                #endif
            }
        }
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

