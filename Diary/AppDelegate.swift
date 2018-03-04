//
//  AppDelegate.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 16..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        let app = UIApplication.shared
//        let notificationSettings = UIUserNotificationSettings(types: UIUserNotificationType([.alert, .sound /*, .Badge*/]), categories:nil)
//        app.registerUserNotificationSettings(notificationSettings)
        
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            print(realmURL.absoluteString)
        }
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().tintColor = UIColor(red: 168/255, green: 128/255, blue: 177/255, alpha: 1.0)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let switchValue = UserDefaults.standard.bool(forKey: "lockSwitch")
        if switchValue {
            let passCodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PasswordLoginViewController.reuseIdentifier) as! PasswordLoginViewController
            UIApplication.topViewController()?.present(passCodeVC, animated: true, completion: nil)
        }
    }


}

