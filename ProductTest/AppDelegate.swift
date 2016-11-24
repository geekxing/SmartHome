//
//  AppDelegate.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/22.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON

let baseRequestUrl = "http://118.178.181.188:8080/Project1101/app_deal/"
let codeDescripDict = ["0":"未知错误",
                       "1":"操作成功",
                       "1000":"邮箱或密码错误",
                       "1001":"邮箱不存在",
                       "1002":"邮箱已存在"]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let loginVC = XBLoginViewController()
        let nav = XBNavigationController(rootViewController: loginVC)
        window?.rootViewController = nav
        
        application.setStatusBarStyle(.lightContent, animated: true)
        
        return true
    }
}

