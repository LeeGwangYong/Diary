//
//  PasswordLoginViewController.swift
//  Diary
//
//  Created by 박수현 on 28/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import SmileLock
import SwiftyJSON

enum Password {
    case validate, input
    
    var description: String? {
        switch self {
        case .validate: return "암호를 입력하세요"
        case .input: return "새로운 앱 비밀번호를 입력해주세요"
        }
    }
}

class PasswordLoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordStackView: UIStackView!
    var passwordType: Password = .validate
    var delegate: SettingsTableViewController?
    
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        passwordContainerView.deleteButtonLocalizedTitle = "취소"
        
        //customize password UI
        passwordContainerView.tintColor = UIColor.color(.textColor)
        passwordContainerView.highlightedColor = UIColor.color(.purple)
        
        titleLabel.text = self.passwordType.description
        switch self.passwordType {
        case .input: self.passwordContainerView.touchAuthenticationEnabled = false
        default:
            self.passwordContainerView.touchAuthenticationEnabled = true
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if passwordType == .input {
            self.delegate?.response(isOn: UserDefaults.standard.bool(forKey: "lockSwitch"))
        }
    }
    
    func updatePassword(code: String) {
        let param: [String: Any] = [
            "idx" : UserDefaults.standard.string(forKey: "userIdx"),
            "lockNumber" : code
        ]
        SignService.getSignData(url: "updatelocknum", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                print(dataJSON)
                if dataJSON["code"] == "0000" {
                    UserDefaults.standard.set(self.delegate?.passwordLockSwitch.isOn, forKey: "lockSwitch")
                    UserDefaults.standard.set(code, forKey: "lockPassword")
                    self.navigationController?.popViewController(animated: true)
                } else if dataJSON["code"] == "0014"{
                    self.view.makeToast("잠금비밀번호 업데이트 오류입니다.")
                }
            case .Failure(let failureCode):
                print("Resend Email In Failure : \(failureCode)")
            }
        }
    }
}

extension PasswordLoginViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        
        switch passwordType {
        case .validate:
            switch validation(input) {
            case true:
                validationSuccess()
            case false:
                validationFail()
            }
        case .input:
            updatePassword(code: input)
        }
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            self.validationSuccess()
        } else {
            passwordContainerView.clearInput()
        }
    }
}

private extension PasswordLoginViewController {
    func validation(_ input: String) -> Bool {
        if input ==  UserDefaults.standard.string(forKey: "lockPassword") {
            return true
        }
        return false
    }
    
    func validationSuccess() {
        print("*️⃣ success!")
        self.dismiss(animated: true, completion: nil)
    }
    
    func validationFail() {
        print("*️⃣ failure!")
        passwordContainerView.wrongPassword()
    }
}
