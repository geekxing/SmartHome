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
import DropDown

var datePicker:UIDatePicker? = {
    let dPicker = UIDatePicker()
    dPicker.datePickerMode = .date;
    dPicker.maximumDate = Date()
    dPicker.frame = CGRect(x: 0.0, y: 0.0, width: dPicker.width, height: 250.0)
    return dPicker
}()

let SMErrorDomain  = "com.sm.app"
let XBImagePrefix  = "http://118.178.181.188:8080/"
let XBNotificationLogout = "XBNotificationLogout"
let baseRequestUrl = "http://118.178.181.188:8080/SleepMonitor/"
let Code = "Code"
let Message = "Message"
let XBData = "Data"

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
        
        DropDown.startListeningToKeyboard()
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setDefaultAnimationType(.native)
        
        XBLog.configDDLog()
        
        setupMainViewController()
        commenInitListenEvents()
        
        return true
    }
    
    func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        if let win = window {
            win.top = (newStatusBarFrame.height < 40) ? 0 : 20
            win.height = (newStatusBarFrame.height < 40) ? SCREEN_HEIGHT : SCREEN_HEIGHT - 20
            if newStatusBarFrame.height < 40 {
                for view in win.subviews {
                    view.frame = win.bounds
                }
            }
        }
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
        setupLoginVC()
    }
    
}

