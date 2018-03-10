//
//  SettingsTableViewController.swift
//  Diary
//
//  Created by 박수현 on 26/02/2018.
//  Copyright © 2018 이광용. All rights reserved.
//

import UIKit
import Toast_Swift

protocol UpdateAppPasswordViewControllerDelegate {
    func response(isOn: Bool)
}

class SettingsTableViewController: UITableViewController, UpdateAppPasswordViewControllerDelegate {
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var passwordLockSwitch: UISwitch!
    @IBOutlet weak var logout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logout.addTarget(self, action: #selector(logoutClicked), for: .touchUpInside)
        self.passwordLockSwitch.setOn(UserDefaults.standard.bool(forKey: "lockSwitch"), animated: false)
        self.passwordLockSwitch.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
        tableView.isScrollEnabled = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingLabel.applyGradientWith(startColor: UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1), endColor: UIColor(red: 94/255, green: 37/255, blue: 99/255, alpha: 1))
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == IndexPath(row: 0, section: 0)
             {
                return 60
        }
        return 60
    }
    
    @objc func logoutClicked() {
        let logoutAlert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까? ", preferredStyle: UIAlertControllerStyle.alert)
        logoutAlert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { (action: UIAlertAction!) in
            logoutAlert .dismiss(animated: true, completion: nil)
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action: UIAlertAction!) in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialNavigationController")
            Capsule.removeAll()
            UIApplication.shared.keyWindow?.rootViewController = nextVC
        }))
        
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func response(isOn: Bool) {
        self.passwordLockSwitch.setOn(isOn, animated: true)
    }
    
    @objc func switchValueDidChange(sender: UISwitch!) {
        if sender.isOn {
            if UserDefaults.standard.string(forKey: "lockPassword") == nil {
                self.view.makeToast("잠금 비밀번호 변경을 통해 비밀번호를 설정해주세요")
                let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PasswordLoginViewController.reuseIdentifier) as! PasswordLoginViewController
                nextVC.passwordType = .input
                nextVC.delegate = self
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(nextVC, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
            else {
                UserDefaults.standard.set(true, forKey: "lockSwitch")
            }
        } else {
            UserDefaults.standard.set(false, forKey: "lockSwitch")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 1, section: 1):
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PasswordLoginViewController.reuseIdentifier) as! PasswordLoginViewController
            nextVC.delegate = self
            nextVC.passwordType = .input
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        case IndexPath(row: 0, section: 2):
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TermsOfServiceViewController.reuseIdentifier)
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        case IndexPath(row: 0, section: 3):
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ExistingPasswordViewController.reuseIdentifier)
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        default: break
        }
    }
}
