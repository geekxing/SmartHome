//
//  XBOperateUtils.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/15.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class XBOperateUtils: NSObject {

    static let shared = XBOperateUtils()
    
    func login(email:String, token:String, success:@escaping (_ result:Any)->(), failure:@escaping (_ error:Error)->()) {
        let params = [
            "Email":email,
            "password":token
        ]
        
        let urlString = baseRequestUrl + "login/login"
        
        XBNetworking.share.postWithPath(path: urlString, paras: params,
                                        success: {result in
                                            print(result)
                                            let json:JSON = result as! JSON
                                            let message = json[Message].stringValue
                                            if json[Code].intValue == 1 {  //登录成功
                                                //登录信息本地缓存
                                                let loginData = LoginData(account: email, token: token)
                                                XBLoginManager.shared.currentLoginData = loginData
                                                //用户信息本地缓存
                                                self .setDefaultRealmForUser(username: email)
                                                XBUserManager.shared.addUser(userJson: json[data])
                                                success(message)
                                            } else {   //服务器返回失败原因
                                                failure(NSError(domain: SMErrorDomain, code: json[Code].intValue, userInfo: [kCFErrorLocalizedDescriptionKey as AnyHashable :message]))
                                            }
        }, failure: { error in
            failure(error)
        })
    }
    
    func todayDateComponents() -> (year:Int, month:Int, day:Int) {
        let today = Date()
        let dateSet: Set<Calendar.Component> = [.year, .month, .day]
        let cmps = Calendar(identifier: .gregorian).dateComponents(dateSet, from: today)
        return (cmps.year!, cmps.month!, cmps.day!)
    }
    
    //MARK: - 获取某年某月的天数
    func howManyDaysInThisYear(_ year:Int, _ month:Int) -> Int{
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31 ;
        }
    
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30;
        }
    
        if(year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3)
        {
            return 28;
        }
    
        if(year % 400 == 0) {
            return 29;
        }
    
        if(year % 100 == 0) {
            return 28;
        }
        
        return 29;
    }
    
    
    private func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        // 使用默认的目录，但是使用用户名来替换默认的文件名
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(username).realm")
        
        // 将这个配置应用到默认的 Realm 数据库当中
        Realm.Configuration.defaultConfiguration = config
    }
}
