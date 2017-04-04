//
//  XBVerifyCodeViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/4/1.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class XBVerifyCodeViewController: XBFindPasswordController {

    let codeField = XBRoundedTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeField.placeholder = "Verify code"
        view.addSubview(codeField)
        
        emailField.isEnabled = false
        emailField.text = email
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        codeField.width = emailField.width*UIRate
        codeField.height = 29
        codeField.centerX = view.centerX
        codeField.top = UIRateH*200 + 229
    }
    
    @IBAction override func submit(_ sender: UIButton) {
        if (emailField.isBlank() || codeField.isBlank()) {
            self.view.makeToast("Message is not Completed")
            return
        }
        let params = ["email":email!,
                      "verifi":codeField.text!]
        emailField.resignFirstResponder()
        
        SVProgressHUD.show()
        XBNetworking.share.postWithPath(path: VERIFY_CODE, paras: params,
                                        success: {[weak self]result in
                                            print(result)
                                            let json:JSON = result as! JSON
                                            let message = json[Message].stringValue
                                            if json[Code].intValue == normalSuccess {
                                                SVProgressHUD.showSuccess(withStatus: message)
                                                let modifyPwd = XBModifyPasswordViewController(nibName: "XBFindPasswordController", bundle: nil)
                                                modifyPwd.email = self?.email
                                                self!.navigationController?.pushViewController(modifyPwd, animated: true)
                                            } else {
                                                SVProgressHUD.showError(withStatus: message)
                                            }
            }, failure: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        })
    }
    

}
