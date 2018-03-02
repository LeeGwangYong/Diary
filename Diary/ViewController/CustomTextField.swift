//
//  CustomTextField.swift
//  Diary
//
//  Created by 박수현 on 28/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//
import UIKit
import Foundation

protocol DeletableTextFieldDelegate {
    func textFieldDidSelectDeleButton(_ textField: UITextField) -> Void
}

class CustonTextField: UITextField, UITextFieldDelegate {
    
}
