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
    func textFieldDidSelectDeleteButton(_ textField: UITextField) -> Void
}

class CustomTextField: UITextField, UITextFieldDelegate {
    var deletableDelegate: DeletableTextFieldDelegate?
    private var characterLimit: Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = characterLimit else {
                return Int.max
            }
            return length
        }
        set {
            characterLimit = newValue
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else { return true }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return prospectiveText.count <= maxLength
    }
    
    override func deleteBackward() {
        self.deletableDelegate?.textFieldDidSelectDeleteButton(self)
        super.deleteBackward()
    }
}
