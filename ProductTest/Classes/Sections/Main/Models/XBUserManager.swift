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
    dynamic var id:String!
    dynamic var userId:String!
    dynamic var email:String!
    dynamic var follower:String?
    dynamic var firstName = ""
    dynamic var middleName:String?
    dynamic var lastName = ""
    dynamic var name:String?
    dynamic var image = ""
    dynamic var password:String!
    dynamic var mphone:String!
    dynamic var address:String?
    dynamic var gender:Int = 0
    dynamic var birthDay:String!
    dynamic var focus:String?
    dynamic var device:String?
    dynamic var createTime = 0.0
    
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
        return "email"
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
    
    func Name() -> String {
        let middleName = self.middleName ?? ""
        return firstName + " " + middleName + " " + lastName
    }
}

class XBUserManager: NSObject {
    static let shared = XBUserManager()
    
    
    //MARK: -
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
            var value:String = ""
            if key == "birthDay" {
                if let dict = subJson.dictionary {
                    if dict.keys.contains("birthDay") {
                        value = dict["birthDay"]!.stringValue
                    } else {
                        let year = dict["year"]!.stringValue
                        let month = dict["month"]!.stringValue
                        let day  = dict["day"]!.stringValue
                        value = "\(month)/\(day)/\(year)"                        
                    }
                }
            } else {
                value = subJson.stringValue
            }
            user.setValue(value, forKey: key)
        }
        try! realm.write {
            realm.add(user, update: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: XBUserInfoHasChangedNotification), object: user.email)
        }
    }
    
    func add(user:XBUser) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    func avatarImageForUser(uid:String) -> UIImage {
        return user(uid: uid)?.gender == 1 ? #imageLiteral(resourceName: "avatar_male") : #imageLiteral(resourceName: "avatar_female")
    }
    
    ///
    /// 返回单个用户信息
    ///
    /// - Parameter uid:用户id
    ///
    /// - Returns:当前登录账号
    func user(uid:String) -> XBUser? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "email = %@", argumentArray: [uid])
        return realm.objects(XBUser.self).filter(predicate).first
    }
    
    ///
    /// 从服务器返回指定账号的用户信息
    ///
    /// - Parameter uid:用户id
    ///
    /// - Returns:查询到的用户信息
    
    func fetchUserFromServer(token:String, handler: @escaping ((_ user:XBUser?, _ error: Error?) -> Void)) {
        
        let params = ["token":token]
        var usr:XBUser?
        XBNetworking.share.postWithPath(path: GET_INFO, paras: params,
                                        success: { result in
                                            let json:JSON = result as! JSON
                                            if json[Code].intValue == 1 {
                                                let userData = json[XBData]
                                                let email = userData["email"].stringValue
                                                //用户信息本地缓存
                                                XBUserManager.shared.addUser(userJson: userData)
                                                usr = XBUserManager.shared.user(uid: email)
                                            }
                                            handler(usr, nil)
            }, failure: { (error) in
                handler(usr, error)
        })
        
    }
    
    
    //MARK: - Class Func
    class func integerForGender(_ gender:String) -> Int {
        return gender == "Male" ? 1 : 0;
    }
    
    class func genderForInt(_ genderIndex:Int) -> String {
        return genderIndex == 0 ? "Female" : "Male"
    }
}
