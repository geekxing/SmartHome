//
//  XBLoginViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/23.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift
import SVProgressHUD
import RealmSwift

class XBLoginViewController: UIViewController,UITextFieldDelegate, XBRegisterViewControllerDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var findPasswordBtn: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var loginData:LoginData? = nil
    
    init() {
        super.init(nibName: "XBLoginViewController", bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "XBLoginViewController", bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loginData = XBLoginManager.shared.currentLoginData {
            usernameTextField.text = loginData.account
            passwordTextField.text = loginData.token
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" && textField.returnKeyType == .done {
            doLogin()
            return false
        }
        return true
    }
    
    @objc private func textFieldDidChange(notification:NSNotification) {
        onTextChanged()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onTextChanged()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            IQKeyboardManager.sharedManager().goNext()
        } else {
            doLogin()
        }
        return true
    }
    
    //MARK: - Action
    func doLogin() {
        view.endEditing(true)
        
        let username = usernameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text
        
        XBOperateUtils.shared.login(email: username!, token: password!, success: { [weak self] (result) in
            XBLoginManager.shared.currentLoginData = LoginData(account: username, token: password)
            self?.navigationController!.pushViewController(XBMainViewController(), animated: true)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    @IBAction func onTouchLogin(_ sender: UIButton) {
        doLogin()
    }
    
    @IBAction func onTouchRegister(_ sender: UIButton) {
        let registerVC = XBRegisterViewController()
        registerVC.delegate = self
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func onTouchFindPwd(_ sender: UIButton) {
        let findPwdVC = XBFindPasswordController()
        navigationController?.pushViewController(findPwdVC, animated: true)
    }
    
    //MARK: - XBRegisterViewControllerDelegate
    func regisDidComplete(account: String?, password pwd: String?) {
        usernameTextField.text = account
        passwordTextField.text = pwd
    }
    
    //MARK: - Private
    private func setAllTextFieldReturnType(type:UIReturnKeyType) {
        for subview in view.subviews[0].subviews {
            if subview.isKind(of: UITextField.self) {
                let textField = subview as! UITextField
                textField.returnKeyType = type
            }
        }
    }
    
    private func onTextChanged() {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            loginButton.isEnabled = false
            setAllTextFieldReturnType(type: .next)
        } else {
            loginButton.isEnabled = true
            setAllTextFieldReturnType(type: .done)
        }
    }
}
