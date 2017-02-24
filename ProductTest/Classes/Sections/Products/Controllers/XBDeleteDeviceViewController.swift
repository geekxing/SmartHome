//
//  XBDeleteDeviceViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/20.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class XBDeleteDeviceViewController: UIViewController {
    
    @IBOutlet weak var snField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var loginUser:XBUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        snField.text = loginUser?.type1sn
        backButton.layer.cornerRadius = backButton.height * 0.5
        submitButton.layer.cornerRadius = submitButton.height * 0.5
    }
    
    //MARK: - Action
    
    @IBAction func submit(_ sender: UIButton) {
        deletDevice(sn: snField.text ?? "")
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Private
    
    private func deletDevice(sn:String) {
        
        if let email = XBUserManager.shared.currentAccount() {
            let params:Dictionary = ["Email":email,
                                     "SN":sn]
            
            let url = baseRequestUrl + "product/delete"
            
            SVProgressHUD.show()
            XBNetworking.share.postWithPath(path: url, paras: params,
                                            success: {[weak self]result in
                                                
                                                let json:JSON = result as! JSON
                                                let message = json[Message].stringValue
                                                if json[Code].intValue == deleteDevice {
                                                    SVProgressHUD.showSuccess(withStatus: message)
                                                    self!.checkUserInfo()
                                                } else {
                                                    SVProgressHUD.showError(withStatus: message)
                                                }
                }, failure: { (error) in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
            })
            
        }
        
    }
    
    private func checkUserInfo() {
        
        XBOperateUtils.shared.login(email: loginUser.Email, token: loginUser.password, success: { (result) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: { [weak self] in
                self!.navigationController!.popViewController(animated: true)
            })
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
        
    }

}