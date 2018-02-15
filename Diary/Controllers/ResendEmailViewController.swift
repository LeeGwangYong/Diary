//
//  ResendEmailViewController.swift
//  Diary
//
//  Created by 박수현 on 15/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit

class ResendEmailViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var authCode01: UITextField!
    @IBOutlet weak var authCode02: UITextField!
    @IBOutlet weak var authCode03: UITextField!
    @IBOutlet weak var authCode04: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        authCode01.delegate = self
        authCode02.delegate = self
        authCode03.delegate = self
        authCode04.delegate = self
    
        let text = "인증코드를 이메일로\n보냈습니다"
        textLabel.text = text
        //textLabel.font = UIFont(name: "SpoqaHanSans-Bold", size: 28)
        textLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
        authCodeSetup()
        drawCompleteButton()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    @objc func drawCompleteButton(){
        let completeButton: UIButton!
        completeButton = UIButton(type: .custom)
        completeButton.frame = CGRect(x: 124, y: 304, width: 127, height: 42)
        //completeButton.titleLabel!.font =  UIFont(name: "SpoqaHanSans-Regular", size: 16)
        completeButton.layer.cornerRadius = 4
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0), for: .normal)
        completeButton.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        
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
        
        authCode01.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        authCode02.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        authCode03.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        authCode04.addBorderBottom(height: 1.0, color: UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0))
        
        authCode01.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        authCode02.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        authCode03.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        authCode04.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    @objc func textChanged(sender: UITextField) {
        if (sender.text?.count)! ==  1 {
            let nextField = sender.superview?.viewWithTag(sender.tag + 1) as UIResponder!
            nextField?.becomeFirstResponder()
            sender.isUserInteractionEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
