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

class VerifyEmailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var questionLabel: UILabel!
    
   
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var authCode01: UITextField!
    @IBOutlet weak var authCode02: UITextField!
    @IBOutlet weak var authCode03: UITextField!
    @IBOutlet weak var authCode04: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var resendEmailButton: UIButton!
    var activeAccountFlag: String = ""
    var idx = UserDefaults.standard.integer(forKey: "userIdx")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTextLabel()
        authCodeSetup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        authCode01.delegate = self
        authCode02.delegate = self
        authCode03.delegate = self
        authCode04.delegate = self
        
        drawCompleteButton()
        self.authCode01.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
        self.authCode02.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
        self.authCode03.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
        self.authCode04.addTarget(self, action: #selector(drawCompleteButton), for: UIControlEvents.editingChanged)
        self.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        resendEmailButton.addTarget(self, action: #selector(resendEmailButtonClicked), for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
<<<<<<< HEAD
=======
        self.view.bringSubview(toFront: self.indicatorView)
>>>>>>> 513c3926090023db0ad57d34148d109957bb0a5d
    }
    
    func setTextLabel() {
        let text = "인증코드를 이메일로\n보냈습니다"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc func drawCompleteButton(){
        completeButton.layer.cornerRadius = 4
        if (authCode01.text?.isEmpty)! || (authCode02.text?.isEmpty)! || (authCode03.text?.isEmpty)! || (authCode04.text?.isEmpty)! {
            completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        } else {
            completeButton.backgroundColor = UIColor(red: 96/255, green: 60/255, blue: 115/255, alpha: 1.0)
        }
        self.view.addSubview(completeButton)
    }
    
    func authCodeSetup() {
        authCode01.tag = 1
        authCode02.tag = 2
        authCode03.tag = 3
        authCode04.tag = 4

        authCode01.textAlignment = .center
        authCode02.textAlignment = .center
        authCode03.textAlignment = .center
        authCode04.textAlignment = .center
        
        authCode01.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        authCode02.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        authCode03.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        authCode04.addBorderBottom(height: 2.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        
        authCode01.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        authCode02.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        authCode03.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        authCode04.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    func appendAuthCode() {
        activeAccountFlag.append(authCode01.text!)
        activeAccountFlag.append(authCode02.text!)
        activeAccountFlag.append(authCode03.text!)
        activeAccountFlag.append(authCode04.text!)
        print(activeAccountFlag)
    }
    
    @objc func textChanged(sender: UITextField) {
        if (sender.text?.count)! ==  1 {
            let nextField = sender.superview?.viewWithTag(sender.tag + 1) as UIResponder!
            nextField?.becomeFirstResponder()
        }
    }
    
    @objc func completeButtonClicked() {
        appendAuthCode()
        checkAuthCode()
    }
    
    func checkAuthCode(){
        self.indicatorView.startAnimating()
        let param: Parameters = [
            "idx" : idx,
            "activeAccountCode" : activeAccountFlag
        ]
        SignService.getSignData(url: "verifyemail", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                if dataJSON["code"] == "0000" {
                    self.indicatorView.stopAnimating()
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                } else {
                    self.view.makeToast("인증코드 오류", duration: 1, position: .center, title: nil, image: nil, style: ToastStyle.init())
                }
            case .Failure(let failureCode):
                print("Verify In Failure : \(failureCode)")
                
            }
        }
    }
    @objc func resendEmailButtonClicked() {
        let param: Parameters = [
            "idx" : idx,
            "email" : UserDefaults.standard.string(forKey: "email")!
        ]
        SignService.getSignData(url: "resendverifyemail", parameter: param) { (result) in
            switch result {
            case .Success(let response):
                let data = response
                let dataJSON = JSON(data)
                print(dataJSON)
                if dataJSON["code"] == "0000" {
                    self.view.makeToast("이메일을 재전송 하였습니다.", duration: 1, position: .center, title: nil, image: nil, style: ToastStyle.init())
                    self.checkAuthCode()
                } else {
                    self.view.makeToast("인증코드 오류", duration: 1, position: .center, title: nil, image: nil, style: ToastStyle.init())
                }
            case .Failure(let failureCode):
                print("Verify In Failure : \(failureCode)")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
