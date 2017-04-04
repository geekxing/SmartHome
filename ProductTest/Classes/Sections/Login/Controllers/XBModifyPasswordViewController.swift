//
//  XBModifyPasswordViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/4/1.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class XBModifyPasswordViewController: XBFindPasswordController {
    
    let passwordField = XBRoundedTextField()
    let confirmPasswordField = XBRoundedTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.isEnabled = false
        emailField.text = email
        
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "New Password"
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.placeholder = "Confirm Password"
        
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        passwordField.width = emailField.width*UIRate
        passwordField.height = 29
        passwordField.centerX = view.centerX
        passwordField.top = UIRateH*200 + 229
        
        confirmPasswordField.width = passwordField.width
        confirmPasswordField.height = 29
        confirmPasswordField.centerX = view.centerX
        confirmPasswordField.top = passwordField.bottom + 30
    }
    
    @IBAction override func submit(_ sender: UIButton) {
        if (emailField.isBlank() || passwordField.isBlank() || confirmPasswordField.isBlank()) {
            self.view.makeToast("Message is not Completed")
            return
        }
        if passwordField.text != confirmPasswordField.text {
            self.view.makeToast("两次密码输入不一致！")
            return
        }
        let params = ["email":email!,
                      "password":passwordField.text!]
        emailField.resignFirstResponder()
        
        SVProgressHUD.show()
        XBNetworking.share.postWithPath(path: MODIFY_PWD, paras: params,
                                        success: {[weak self]result in
                                            print(result)
                                            let json:JSON = result as! JSON
                                            let message = json[Message].stringValue
                                            if json[Code].intValue == normalSuccess {
                                                SVProgressHUD.showSuccess(withStatus: message)
                                                self!.navigationController!.popToRootViewController(animated: true)
                                            } else {
                                                SVProgressHUD.showError(withStatus: message)
                                            }
            }, failure: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        })
    }

}
