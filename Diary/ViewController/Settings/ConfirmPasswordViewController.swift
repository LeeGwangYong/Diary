//
//  ConfirmPasswordViewController.swift
//  Diary
//
//  Created by 박수현 on 27/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

class ConfirmPasswordViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTextLabel()
        customLoginButton()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setTextLabel() {
        let text = "비밀번호가\n변경되었습니다"
        questionLabel.text = text
        questionLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        
    }
    func customLoginButton() {
        loginButton.createGradientLayer()
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
    }
    @objc func loginButtonClicked() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialNavigationController")
        UIApplication.shared.keyWindow?.rootViewController = nextVC
    }
}
