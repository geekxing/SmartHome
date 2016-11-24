//
//  XBLoginViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/23.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit

class XBLoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var findPasswordBtn: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configStatusBar()
    }

    func configStatusBar() {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated:false)
    }
    
    //MARK:UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            doLogin()
            return false
        }
        return true
    }
    
    @objc private func textFieldDidChange(notification:NSNotification) {
        if usernameTextField.text!.isEmpty && passwordTextField.text!.isEmpty {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if usernameTextField.text!.isEmpty && passwordTextField.text!.isEmpty {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    //MARK:Action
    func doLogin() {
        view.endEditing(true)
        let username = usernameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text
        
    }
    @IBAction func onTouchLogin(_ sender: UIButton) {
        doLogin()
    }
    @IBAction func onTouchRegister(_ sender: UIButton) {
        let registerVC = XBRegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
