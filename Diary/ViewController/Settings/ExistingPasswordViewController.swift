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

class ExistingPasswordViewController: UIViewController {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var passwordAlertLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLabel()
        self.view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNextButton()
        self.passwordField.addTarget(self, action: #selector(setNextButton), for: UIControlEvents.editingChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.view.bringSubview(toFront: indicatorView)
    }
    @objc func setNextButton(){
        completeButton.layer.cornerRadius = 4
        if passwordField.text!.isEmpty {
            passwordAlertLabel.isHidden = true
            completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
            completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        } else {
            if passwordField.text!.count < 8 {
                passwordAlertLabel.text = "8자 이상 입력해주세요"
                passwordAlertLabel.isHidden = false
                completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
                completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
            } else {
                passwordAlertLabel.isHidden = true
                completeButton.backgroundColor = UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0)
                completeButton.setTitleColor(UIColor.white, for: .normal)
                completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
            }
        }
        self.view.addSubview(completeButton)
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
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
