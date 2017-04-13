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
import Photos

class XBAddDeviceViewController: UIViewController {
    
    @IBOutlet weak var snField: UITextField!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    let token = XBLoginManager.shared.currentLoginData!.token
    private var typeSn:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultMaskType(.clear)
        
        snField.setValue(XB_DARK_TEXT, forKeyPath: "placeholderLabel.textColor")
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
        
        if !cameraAvailable() {
            return
        }
        checkCameraAuth {[weak self] (flag) in
            if flag {
                let qrVC = XBQRCodeScanViewController()
                qrVC.returnScan = {[weak self] scan in
                    self?.snField.text = scan
                }
                self?.navigationController?.pushViewController(qrVC, animated: true)
            }
        }
        
    }

    @IBAction func textTapReturnKey(_ sender: UITextField) {
        submit(submitButton)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        addDevice(sn: snField.text ?? "")
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    
    //MARK: - Camera Access
    func cameraAvailable() -> Bool {
        let available = UIImagePickerController.isSourceTypeAvailable(.camera)
        if !available {
            let alert = UIAlertView(title: NSLocalizedString("your device has no access to camera", comment: ""), message: "", delegate: nil, cancelButtonTitle: "DONE")
            alert.show()
        }
        return available
    }
    
    func checkCameraAuth(_ request:@escaping (Bool)->()) {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == .denied || authStatus == .restricted) {
            return
        }else {
            if authStatus == .authorized {
                request(true)
            } else {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (grand) in
                    if grand {
                        DispatchQueue.main.async(execute: {
                            request(grand)
                        })
                    }
                })
            }
        }
    }

    //MARK: - Private
    private func addDevice(sn:String) {
        
        if (sn as NSString).length < 20 {
            UIAlertView(title: "sn长度小于20位", message: nil, delegate: nil, cancelButtonTitle: "DONE").show()
            return
        }
        
        let params:Dictionary = ["token":token,
                                 "sn_all":sn]
        
        SVProgressHUD.show()
        XBNetworking.share.postWithPath(path: DEVICE_ADD, paras: params,
                                        success: {[weak self] json in
    
                                            let message = json[Message].stringValue
                                            let code = json[Code].intValue
                                            if code == normalSuccess || code == 1002 {
                                                self!.checkUserInfo(self!.token)
                                            } else {
                                                SVProgressHUD.showError(withStatus: message)
                                            }
            }, failure: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        })

    }
    
    private func checkUserInfo(_ token:String) {
        
        XBUserManager.shared.fetchUserFromServer(token: token, handler: { (user, error) in
            if error == nil {
                let bleVC = CBCentralViewController()
                self.navigationController!.pushViewController(bleVC, animated: true)
            }
        })
        
    }

}
