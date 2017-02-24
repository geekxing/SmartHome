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

class XBFindPasswordController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = backButton.height * 0.5
        submitButton.layer.cornerRadius = submitButton.height * 0.5
    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        email = oldText.replacingCharacters(in: range, with: string)
        let newText = email! as NSString
        submitButton.isEnabled = newText.length != 0
        return true
    }

    @IBAction func submit(_ sender: UIButton) {
        if (email == nil) {
            self.view.makeToast("Message is not Completed")
            return
        }
        let params = ["Email":email!]
        let url = baseRequestUrl + "login/forget"
        emailField.resignFirstResponder()
        
        SVProgressHUD.show()
        XBNetworking.share.getWithPath(path: url, paras: params,
                                       success: {[weak self]result in
                                        print(result)
                                        let json:JSON = result as! JSON
                                        let message = json[Message].stringValue
                                        if json[Code].intValue == tokenSend {
                                            SVProgressHUD.showSuccess(withStatus: message)
                                            self?.back(self!.backButton!)
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
