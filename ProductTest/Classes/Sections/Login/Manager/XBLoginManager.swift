//
//  XBLoginManager.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/4.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit

let XBAccount = "account"
let XBToken   = "token"

class LoginData: NSObject, NSCoding {
    var account:String!
    var token:String!
    
    func encode(with aCoder: NSCoder) {
        let acc = account as NSString
        let tok = token as NSString
        if acc.length != 0 {
            aCoder.encode(account, forKey: XBAccount)
        }
        if tok.length != 0 {
            aCoder.encode(token, forKey: XBToken)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        account = aDecoder.decodeObject(forKey: XBAccount) as! String!
        token = aDecoder.decodeObject(forKey: XBToken) as! String!
    }
    
    override init() {
    }
    
    convenience init(account:String?, token:String?) {
        self.init()
        self.account = account
        self.token = token
    }
}

class XBLoginManager: NSObject {
    static let shared = XBLoginManager()
    
    var filepath:String?
    var currentLoginData:LoginData? = nil {
        didSet {
            saveData()
        }
    }
    
    override init() {
        super.init()
        let filePath = XBFileLocationHelper.getAppDocumentPath() + "/xb_login_data"
        self.filepath = filePath
        readData()
    }
    
    func readData() {
        let filePath = self.filepath!
        if FileManager.default.fileExists(atPath: filePath) {
            let obj = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
            if let loginData = obj as? LoginData {
                currentLoginData = loginData
            }
        }
    }
    
    func saveData()  {
        var data = Data()
        if currentLoginData != nil {
            data = NSKeyedArchiver.archivedData(withRootObject: currentLoginData!)
        }
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("xb_login_data")
        do {
            try data.write(to: fileURL)
        } catch  {print("登录信息写入失败")}
    }

}
