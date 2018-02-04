//
//  LoginViewController.swift
//  Diary
//
//  Created by 박수현 on 17/01/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var dict : [String : AnyObject]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!

    let buttonText = NSAttributedString(string: "FaceBook으로 로그인")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        pwTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        self.emailTextField.delegate = self
        self.pwTextField.delegate = self

        //Custom Facebook login button
        let facebookLoginButton = UIButton(type: .custom)
        facebookLoginButton.frame = CGRect(x: 30, y: 435, width: view.frame.width - 61, height: 35)
        facebookLoginButton.setTitle("FaceBook으로 로그인", for: .normal)
        facebookLoginButton.tintColor = UIColor.white
        facebookLoginButton.backgroundColor = UIColor.gray
        facebookLoginButton.addTarget(self, action: #selector(faceBookLoginButtonClicked), for: .touchUpInside)
        view.addSubview(facebookLoginButton)
        //adding it to view
        view.addSubview(facebookLoginButton)
        //if the user is already logged in
        if let accessToken = FBSDKAccessToken.current(){
            getFaceBookUserData()
        }
    }
    
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        pwTextField.resignFirstResponder()
        return (true)
    }

    //fix back button title
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "취소"
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK:- Facebook Login
    @objc func faceBookLoginButtonClicked() {
        let faceBookLoginManager = LoginManager()
        faceBookLoginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { faceBookLoginResult in
            switch faceBookLoginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFaceBookUserData()
            }
        }
    }
    
    //function is fetching the user data
    func getFaceBookUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
 
}
//TextField under line
extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

