//
//  SignUpViewController.swift
//  Diary
//
//  Created by 박수현 on 17/01/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBAction func signUpAction(_ sender: Any) {
        doSignUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        emailTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        pwTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SignUpViewController{
    func showAlert(message:String){
        let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }
    func doSignUp(){
        if emailTextField.text == ""{
            showAlert(message: "이메일을 입력해주세요")
            return
        }
        if pwTextField.text == ""{
            showAlert(message: "비밀번호를 입력해주세요")
            return
        }
        signUp(email: emailTextField.text!, password: pwTextField.text!)
    }
    func signUp(email:String, password:String){
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user,error) in
            if error != nil{
                if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!){
                    switch ErrorCode {
                    case AuthErrorCode.invalidEmail:
                        self.showAlert(message: "유효하지 않은 이메일입니다")
                    case AuthErrorCode.emailAlreadyInUse:
                        self.showAlert(message: "이미 가입한 이메일입니다")
                        
                    case AuthErrorCode.weakPassword:
                        self.showAlert(message: "비밀번호는 6자리 이상입니다")
                    default:
                        print(ErrorCode)
                    }
                }
            } else{
                print("회원가입 성공")
                dump(user)
            }
        })
    }
}
