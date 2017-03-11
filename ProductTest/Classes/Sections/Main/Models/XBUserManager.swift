//
//  XBUserManager.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/5.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

let XBUserInfoHasChangedNotification = "XBUserInfoHasChangedNotification"

class XBUser: Object {
    dynamic var Email:String!
    dynamic var firstName:String! = " "
    dynamic var middleName:String? = " "
    dynamic var lastName:String! = " "
    dynamic var Name:String!
    dynamic var image:String? = " "
    dynamic var password:String!
    dynamic var phoneNumber:String!
    dynamic var address:String?
    dynamic var gender:String?
    dynamic var yearOfBirth:String!
    dynamic var type1sn:String?
    dynamic var type1Ip:String?
    dynamic var level1:String?
    dynamic var deadline1:String?
    dynamic var type2sn:String?
    dynamic var type2Ip:String?
    dynamic var level2:String?
    dynamic var deadline2:String?
    dynamic var type3sn:String?
    dynamic var type3Ip:String?
    dynamic var level3:String?
    dynamic var deadline3:String?
    
    override static func primaryKey() -> String? {
        return "Email"
    }
    
    func properties_name() -> [String] {
        var count:UInt32 = 0
        let ivars = class_copyIvarList(XBUser.self, &count)
        var properties_name = [String]()
        for i in 0..<count {
            let ivar = ivars?[Int(i)]
            let ivarName = ivar_getName(ivar!)
            let nName = String(cString: ivarName!)
            properties_name.append(nName)
        }
        return properties_name
    }
}

class XBUserManager: NSObject {
    static let shared = XBUserManager()
    
    ///
    /// 返回当前登录账号
    ///
    /// - Returns: 当前登录账号
    ///
    func currentAccount() -> String? {
        return XBLoginManager.shared.currentLoginData?.account
    }
    
    ///
    /// 返回当前登录用户信息
    ///
    /// - Returns: 当前登录用户信息
    ///
    func loginUser() -> XBUser? {
        if let userID = XBUserManager.shared.currentAccount() {
            if let loginUser = XBUserManager.shared.user(uid: userID) {
                return loginUser
            }
        }
        return nil
    }
    
    func addUser(userJson:JSON) {
        //用户信息本地缓存
        let realm = try! Realm()
        print(realm.configuration.fileURL!)
        let user = XBUser()
        for (key,subJson):(String, JSON) in userJson {
            user.setValue(subJson.stringValue, forKey: key)
        }
        try! realm.write {
            realm.add(user, update: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: XBUserInfoHasChangedNotification), object: user.Email)
        }
    }
    
    func add(user:XBUser) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    func avatarImageForUser(uid:String) -> UIImage {
        return user(uid: uid)?.gender == "Male" ? #imageLiteral(resourceName: "avatar_male") : #imageLiteral(resourceName: "avatar_female")
    }
    
    ///
    /// 返回单个用户信息
    ///
    /// - Parameter uid:用户id
    ///
    /// - Returns:当前登录账号
    func user(uid:String) -> XBUser? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "Email = %@", argumentArray: [uid])
        return realm.objects(XBUser.self).filter(predicate).first
    }
}
