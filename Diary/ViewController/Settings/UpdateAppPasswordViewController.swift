//
//  UpdateAppPasswordViewController.swift
//  Diary
//
//  Created by 박수현 on 28/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UpdateAppPasswordViewController: UIViewController {

 
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var passwordAlertLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLabel()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNextButton()
        self.passwordField.addTarget(self, action: #selector(setNextButton), for: UIControlEvents.editingChanged)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.view.bringSubview(toFront: indicatorView)
        passwordField.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
    }
    @objc func setNextButton(){
        completeButton.layer.cornerRadius = 4
        if passwordField.text!.isEmpty {
            passwordAlertLabel.isHidden = true
            completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
            completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        } else {
            if passwordField.text!.count < 4 {
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
        let text = "새로운 잠금 비밀번호를\n입력해주세요"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
    }
    
    @objc func completeButtonClicked() {
        UserDefaults.standard.set(passwordField.text, forKey: "lockPassword")
        updatePassword()
    }
    
    func updatePassword() {
        self.indicatorView.startAnimating()
        let param: Parameters = [
            "idx" : UserDefaults.standard.string(forKey: "userIdx"),
            "lockNumber" : passwordField.text!
        ]
        SignService.getSignData(url: "updatelocknum", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                print(dataJSON)
                if dataJSON["code"] == "0000" {
                    self.indicatorView.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                    UserDefaults.standard.set(self.passwordField.text, forKey: "lockPassword")
                } else if dataJSON["code"] == "0014"{
                    self.indicatorView.stopAnimating()
                    self.view.makeToast("잠금비밀번호 업데이트 오류입니다.")
                }
            case .Failure(let failureCode):
                print("Resend Email In Failure : \(failureCode)")
            }
        }
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
