//
//  ResetPasswordLoginViewController.swift
//  Diary
//
//  Created by 박수현 on 23/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

class ResetPasswordLoginViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        setTextLabel()
        customLoginButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setTextLabel() {
        let text = "이메일로\n임시 비밀번호를 보냈습니다"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    func customLoginButton() {
        loginButton.createGradientLayer()
       // loginButton.makeRoundedView(corners: [.bottomLeft, .bottomRight])
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
    }
    @objc func loginButtonClicked() {
        UserDefaults.standard.synchronize()
        let password = UserDefaults.standard.string(forKey: "password")
        print(password)
        self.performSegue(withIdentifier: "ResetPasswordLoginSegue", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
