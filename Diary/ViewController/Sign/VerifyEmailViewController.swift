//
//  VerifyEmailViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class VerifyEmailViewController: ViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var completeButton: CustomButton!
    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var codeTextField1: CustomTextField!
    @IBOutlet weak var codeTextField2: CustomTextField!
    @IBOutlet weak var codeTextField3: CustomTextField!
    @IBOutlet weak var codeTextField4: CustomTextField!
    lazy var codeTextFields: [CustomTextField] = [self.codeTextField1,
                                                  self.codeTextField2,
                                                  self.codeTextField3,
                                                  self.codeTextField4]
    var userIdx: Int!
    var email: String!
    var password: String!
    var nickname = UserDefaults.standard.string(forKey: "nickname")
    var code: String {
        var str = ""
        for field in self.codeTextFields {
            if let text = field.text {
                str += text
            }
        }
        return str
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTextLabel()
        authCodeSetup()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        self.completeButton.isEnabled = false
        self.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        resendEmailButton.addTarget(self, action: #selector(resendEmailButtonClicked), for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.view.bringSubview(toFront: self.indicatorView)
    }
    override func setViewController() {
        for (index, field) in codeTextFields.enumerated() {
            field.tag = index
            field.maxLength = 1
            field.delegate = self
            field.deletableDelegate = self
            field.textAlignment = NSTextAlignment.center
        }
        self.codeTextField1.becomeFirstResponder()
    }
    
    func setTextLabel() {
        let text = "인증코드를 이메일로\n보냈습니다"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    
    func authCodeSetup() {
        for field in self.codeTextFields {
            field.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
            field.keyboardType = .numberPad
        }
    }

    @objc func completeButtonClicked() {
        checkAuthCode()
    }
    
    func checkAuthCode(){
        self.indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        let param: Parameters = [
            "idx" : userIdx,
            "activeAccountCode" : code
        ]
        SignService.getSignData(url: "verifyemail", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                if let code = dataJSON["code"].string, code == "0000"{
                    self.indicatorView.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    let completionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CompletionViewController.reuseIdentifier) as! CompletionViewController
                    completionVC.delegate = self
                    completionVC.titleString = "가입완료"
                    completionVC.subTitleText = "\(String(describing: self.nickname!))님을 위한\n기억의 타임캡슐을 만들었습니다."
                    UserDefaults.standard.set(self.userIdx, forKey: "userIdx")
                    UserDefaults.standard.set(self.email, forKey: "email")
                    UserDefaults.standard.set(self.password, forKey: "password")
                    self.present(completionVC, animated: true, completion: nil)

                } else if let code = dataJSON["code"].string, code == "0004"{
                    self.indicatorView.stopAnimating()
                    self.view.makeToast("잘못된 인증코드입니다.")
                } else {
                    self.indicatorView.stopAnimating()
                    self.view.makeToast(dataJSON["errmsg"].stringValue)
                }
            case .Failure(let failureCode):
                #if DEBUG
                print("Verify In Failure : \(failureCode)")
                #endif
                
            }
        }
        self.view.isUserInteractionEnabled = true
    }
    @objc func resendEmailButtonClicked() {
        let param: Parameters = [
            "idx" : userIdx,
            "email" : self.email
        ]
        SignService.getSignData(url: "resendverifyemail", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                #if DEBUG
                print(dataJSON)
                    #endif
                if dataJSON["code"] == "0000" {
                    self.view.makeToast("이메일을 재전송 하였습니다.")
                } else {
                    self.view.makeToast("인증코드 재발송 오류입니다.")
                }
            case .Failure(let failureCode):
                #if DEBUG
                print("Resend Email In Failure : \(failureCode)")
                #endif
            }
        }
    }
    override func customSegue() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension VerifyEmailViewController: DeletableTextFieldDelegate, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? CustomTextField else {return true}
        guard string.count > 0 else { return true}
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters.isSuperset(of: characterSet) {
            if currentText.count == 1 {
                switch textField {
                case self.codeTextField1, self.codeTextField2, self.codeTextField3:
                    textField.resignFirstResponder()
                    self.codeTextFields[textField.tag + 1].becomeFirstResponder()
                    self.codeTextFields[textField.tag + 1].text = string
                    
                    if code.count < 4 {
                        completeButton.isEnabled = false
                    }
                    else if code.count == 4 {
                        completeButton.isEnabled = true
                    }
                case self.codeTextField4:
                    if code.count == 4 {
                        textField.resignFirstResponder()
                    }
                default:
                    break
                }
            }
            return allowedCharacters.isSuperset(of: characterSet) && prospectiveText.count <= textField.maxLength
        }
        return false
    }
    
    func textFieldDidSelectDeleteButton(_ textField: UITextField) {
        if code.count < 4 {
            completeButton.isEnabled = false
        }
        else if code.count == 4 {
            completeButton.isEnabled = true
        }
        switch textField {
        case self.codeTextField2, self.codeTextField3, self.codeTextField4:
            self.codeTextFields[textField.tag - 1].becomeFirstResponder()
        default:
            break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if code.count == 4 {
            completeButtonClicked()
        }
        return true
    }
}
