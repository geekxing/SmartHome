//
//  XBFindPasswordController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/6.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class XBFindPasswordController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = backButton.height * 0.5
        submitButton.layer.cornerRadius = submitButton.height * 0.5
    }

    @IBAction func submit(_ sender: UIButton) {
        email = emailField.text
        if (emailField.isBlank()) {
            self.view.makeToast("Message is not Completed")
            return
        }
        let params = ["email":email!]
        emailField.resignFirstResponder()
        
        SVProgressHUD.show()
        XBNetworking.share.postWithPath(path: FORGET, paras: params,
                                        success: {[weak self]result in
                                            print(result)
                                            let json:JSON = result as! JSON
                                            let message = json[Message].stringValue
                                            if json[Code].intValue == normalSuccess {
                                                SVProgressHUD.showSuccess(withStatus: message)
                                                let verify = XBVerifyCodeViewController(nibName: "XBFindPasswordController", bundle: nil)
                                                verify.email = self?.email
                                                self!.navigationController?.pushViewController(verify, animated: true)
                                            } else {
                                                SVProgressHUD.showError(withStatus: message)
                                            }
            }, failure: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        })
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
