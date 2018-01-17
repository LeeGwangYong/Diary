//
//  LoginViewController.swift
//  Diary
//
//  Created by 박수현 on 17/01/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            
            emailTextField.placeholder = "이미 로그인 된 상태입니다."
            pwTextField.placeholder = "이미 로그인 된 상태입니다."
            loginButton.isHidden = true
            logoutButton.isHidden = false
        }
    }

    @IBAction func loginButtonTouched(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in
            if user != nil{
                print("login success")
                self.loginButton.isHidden = true
                self.logoutButton.isHidden = false
            }
            else{
                print("login fail")
            }
        }
    }
    
    @IBAction func logoutButtonTouched(_ sender: Any) {
        do {
            try Auth.auth() .signOut()
            self.loginButton.isHidden = false
            self.logoutButton.isHidden = true
            emailTextField.placeholder = "dbdiary@db.com"
            pwTextField.placeholder = " 숫자 몇자리를 입력하세요"
            print("logout")
        } catch let error as NSError {
            print(error)
        }
    }
    
    //fix back button title
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "취소"
        navigationItem.backBarButtonItem = backItem
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
