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
    
    
    private func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        // 使用默认的目录，但是使用用户名来替换默认的文件名
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(username).realm")
        
        // 将这个配置应用到默认的 Realm 数据库当中
        Realm.Configuration.defaultConfiguration = config
    }
}
