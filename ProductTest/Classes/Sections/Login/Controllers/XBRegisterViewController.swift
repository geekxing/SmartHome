//
//  XBRegisterViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/23.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class XBRegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    @IBOutlet weak var confirmButton: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    init() {
        super.init(nibName: "XBRegisterViewController", bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "XBRegisterViewController", bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        submitButton.isEnabled = false
    }
    
    //MARK:UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            submit(submitButton)
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
        if textField.returnKeyType == .done {
            submit(submitButton)
        }
        return true
    }

    //MARK:Action
    @IBAction func submit(_ sender: UIButton) {
        let params:Parameters = [
            "Email":usernameTextField.text!,
            "password":passwordField.text ?? "",
            "firstname":firstnameField.text ?? "",
            "lastname":lastnameField.text ?? ""
        ]
        
        let url = baseRequestUrl + "app_register"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let user = json["result"]["User"].dictionaryValue
                print("\(user)")
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    //MARK:Private
    private func setAllTextFieldReturnType(type:UIReturnKeyType) {
        for subview in view.subviews[0].subviews {
            if subview.isKind(of: UITextField.self) {
                let textField = subview as! UITextField
                textField.returnKeyType = type
            }
        }
    }
    
    private func onTextChanged() {
        if usernameTextField.text!.isEmpty || passwordField.text!.isEmpty {
            submitButton.isEnabled = false
            setAllTextFieldReturnType(type: .next)
        } else {
            submitButton.isEnabled = true
            setAllTextFieldReturnType(type: .done)
        }
    }
    
}
