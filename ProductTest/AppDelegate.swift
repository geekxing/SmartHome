//
//  AppDelegate.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/22.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift

let SMErrorDomain  = "com.sm.app"
let XBImagePrefix  = "http://118.178.181.188:8080/"
let XBNotificationLogout = "XBNotificationLogout"
let baseRequestUrl = "http://118.178.181.188:8080/SleepMonitor/"
let Code = "Code"
let Message = "Message"
let data = "data"

//成功码
let normalSuccess = 1
let updateInfo    = 1006
let tokenSend     = 1007
let findUser      = 1011
let applyNotice   = 1013
let applyPass     = 1015
let cancelNotice  = 1017
let bindDevice    = 1024
let deleteDevice  = 1026

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
        SVProgressHUD.setDefaultAnimationType(.native)
        
        setupMainViewController()
        commenInitListenEvents()
        
        application.setStatusBarStyle(.lightContent, animated: true)
        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupMainViewController() {
        //暂时没有自动登录接口
        setupLoginVC()
    }
    
    func setupLoginVC() {
        let loginVC = XBLoginViewController()
        let nav = XBNavigationController(rootViewController: loginVC)
        window?.rootViewController = nav
    }
    
    func commenInitListenEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: XBNotificationLogout), object: nil)
    }
    
    @objc func logout(aNote:Notification) {
        XBLoginManager.shared.currentLoginData?.token = nil
        setupLoginVC()
    }
    
}

