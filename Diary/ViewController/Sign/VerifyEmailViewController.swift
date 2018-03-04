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
    @IBOutlet weak var completeButton: UIButton!
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
    
<<<<<<< HEAD
    
=======
>>>>>>> 354f994ab41c83903798a4f42fb53f2065d15e22
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTextLabel()
        authCodeSetup()
        self.view.layoutIfNeeded()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewController()
        drawCompleteButton()

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
            field.keyboardType = .numberPad
            field.textAlignment = NSTextAlignment.center
        }
        self.codeTextField1.becomeFirstResponder()
    }
    
    func setTextLabel() {
        let text = "인증코드를 이메일로\n보냈습니다"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    @objc func drawCompleteButton(){
        completeButton.layer.cornerRadius = 4
        completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        completeButton.isEnabled = false
        self.view.addSubview(completeButton)
    }
    
    func authCodeSetup() {
        codeTextField1.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        codeTextField2.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        codeTextField3.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        codeTextField4.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
     
    }

    @objc func completeButtonClicked() {
        checkAuthCode()
    }
    
    func checkAuthCode(){
        self.indicatorView.startAnimating()
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
                print("Verify In Failure : \(failureCode)")
                
            }
        }
    }
    @objc func resendEmailButtonClicked() {
        let param: Parameters = [
            "idx" : userIdx,
            "email" : UserDefaults.standard.string(forKey: "email")!
        ]
        SignService.getSignData(url: "resendverifyemail", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                print(dataJSON)
                if dataJSON["code"] == "0000" {
                    self.view.makeToast("이메일을 재전송 하였습니다.")
                } else {
                    self.view.makeToast("인증코드 재발송 오류입니다.")
                }
            case .Failure(let failureCode):
                print("Resend Email In Failure : \(failureCode)")
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
                    completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
                    completeButton.isEnabled = false
                    if code.count == 4 {
                        completeButton.backgroundColor = UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0)
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
        switch textField {
        case self.codeTextField2, self.codeTextField3, self.codeTextField4:
            self.codeTextFields[textField.tag - 1].becomeFirstResponder()
        case self.codeTextField1 :
            self.codeTextField4.becomeFirstResponder()
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
