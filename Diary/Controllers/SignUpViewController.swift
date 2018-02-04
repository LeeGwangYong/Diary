//
//  SignUpViewController.swift
//  Diary
//
//  Created by 박수현 on 17/01/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

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
    }
    
}
