//
//  XBAddDeviceViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/15.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class XBAddDeviceViewController: UIViewController {
    
    @IBOutlet weak var snField: UITextField!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    private var typeSn:String?
    
    var loginUser:XBUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snField.setValue(UIColorHex("333333", 1.0), forKeyPath: "placeholderLabel.textColor")
        scanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 19*UIRate, 0, 0)
        scanButton.contentEdgeInsets = UIEdgeInsetsMake(0, -100, 0, 0)
        scanButton.width = 200
        backButton.layer.cornerRadius = backButton.height * 0.5
        submitButton.layer.cornerRadius = submitButton.height * 0.5
    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        typeSn = oldText.replacingCharacters(in: range, with: string)
        let newText = typeSn! as NSString
        submitButton.isEnabled = newText.length != 0
        return true
    }
    
    //MARK: - Action
    
    @IBAction func beginScan(_ sender: UIButton) {
        let qrVC = XBQRCodeScanViewController()
        qrVC.returnScan = {[weak self] scan in
            self?.snField.text = "00010A0o4i1muso"
        }
        navigationController?.pushViewController(qrVC, animated: true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        addDevice(sn: snField.text ?? "")
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Private
    private func addDevice(sn:String) {
        
        if let email = XBUserManager.shared.currentAccount() {
            let params:Dictionary = ["Email":email,
                                     "SN":sn]
            
            let url = baseRequestUrl + "product/add"
            
            SVProgressHUD.show()
            XBNetworking.share.postWithPath(path: url, paras: params,
                                            success: {[weak self]result in
                                                
                                                let json:JSON = result as! JSON
                                                let message = json[Message].stringValue
                                                if json[Code].intValue == bindDevice {
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
