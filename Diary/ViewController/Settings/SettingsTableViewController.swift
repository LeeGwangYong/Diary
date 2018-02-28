//
//  SettingsTableViewController.swift
//  Diary
//
//  Created by 박수현 on 26/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import Toast_Swift

class SettingsTableViewController: UITableViewController {


    @IBOutlet weak var passwordLockSwitch: UISwitch!
    @IBOutlet weak var logout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logout.addTarget(self, action: #selector(logoutClicked), for: .touchUpInside)
        self.passwordLockSwitch.setOn(UserDefaults.standard.bool(forKey: "lockSwitch"), animated: false)
        self.passwordLockSwitch.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    @objc func logoutClicked() {
        let logoutAlert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까? ", preferredStyle: UIAlertControllerStyle.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LoginViewController.reuseIdentifier)
            self.present(nextVC, animated: true, completion: nil)
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action: UIAlertAction!) in
            logoutAlert .dismiss(animated: true, completion: nil)
        }))
        
        present(logoutAlert, animated: true, completion: nil)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    @objc func switchValueDidChange(sender: UISwitch!) {
        print(sender.isOn)
        if sender.isOn {
            self.passwordLockSwitch.setOn(true, animated: true)
            UserDefaults.standard.set(true, forKey: "lockSwitch")
            if UserDefaults.standard.string(forKey: "lockPassword") == nil {
                self.view.makeToast("잠금 비밀번호 변경을 통해 비밀번호를 설정해주세요")
                let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: UpdateAppPasswordViewController.reuseIdentifier)
                self.present(nextVC, animated: true, completion: nil)
            }
        } else {
            self.passwordLockSwitch.setOn(false, animated: true)
            UserDefaults.standard.set(false, forKey: "lockSwitch")
        }
    }
}
