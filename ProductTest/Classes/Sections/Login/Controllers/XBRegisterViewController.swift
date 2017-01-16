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
import IQKeyboardManagerSwift
import FTPopOverMenu_Swift
import LGAlertView
import Toast_Swift
import SVProgressHUD

public protocol XBRegisterViewControllerDelegate:NSObjectProtocol {
    func regisDidComplete(account:String?, password pwd:String?)
}

let margin = 50.0

class XBRegisterViewController: UIViewController, UITextFieldDelegate, LGAlertViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var middleNameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var pSerialNoField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retypePasswordField: UITextField!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var fullFilled:Bool = false
    weak var delegate:XBRegisterViewControllerDelegate?
    var datePicker:UIDatePicker? = nil
    
    lazy var textfields:[UITextField]? = {
       return []
    }()
    
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
        scrollView.contentSize = CGSize(width: 0, height: backgroundView.height + CGFloat( margin * 2))
        self.automaticallyAdjustsScrollViewInsets = false
        
        middleNameField.tag = -1
        addressField.tag = -1
        pSerialNoField.tag = -1

        findTextfield {[weak self] in
            self!.textfields?.append($0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" && textField.returnKeyType == .done {
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
        if textField == birthField {
            showCalendar()
        } else if (textField == genderField) {
            showGenderSelectView()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            IQKeyboardManager.sharedManager().goNext()
        } else {
            submit(submitButton)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.inputView != nil {
            let pickerView = textField.inputView as! UIDatePicker
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            textField.text = dateFormatter.string(from: pickerView.date)
        }
    }

    //MARK: - Action
    @IBAction func submit(_ sender: UIButton) {
        if (!fullFilled || !checkboxButton.isSelected) {
            self.view.makeToast("Message is not Completed")
            return
        }
        view.endEditing(true)
        
        if !self.validatePassword() {
            return
        }
        
        let params:Parameters = [
            "Email":usernameTextField.text!,
            "password":passwordField.text!,
            "firstName":firstnameField.text!,
            "middleName":middleNameField.text ?? "",
            "lastName":lastnameField.text!,
            "yearOfBirth":birthField.text!,
            "gender":genderField.text!,
            "phoneNumber":phoneNumberField.text!,
            "address":addressField.text ?? "",
            "SN":pSerialNoField.text ?? "",
        ]
        
        let url = baseRequestUrl + "login/register"

        SVProgressHUD.show()
        XBNetworking.share.postWithPath(path: url, paras: params,
            success: {[weak self]result in
                
                let json:JSON = result as! JSON
                let message = json[Message].stringValue
                if json[Code].intValue == 1 {
                    SVProgressHUD.showSuccess(withStatus: message)
                    self!.delegate?.regisDidComplete(account: self?.usernameTextField.text, password: self?.passwordField.text)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: { [weak self] in
                        self?.back(self!.backButton)
                    })
                } else {
                    SVProgressHUD.showError(withStatus: message)
                }
            }, failure: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        })
    }

    @IBAction func check(_ sender: UIButton) {
        checkboxButton.isSelected = !checkboxButton.isSelected
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Private
    private func showCalendar() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date;
        datePicker.frame = CGRect(x: 0.0, y: 0.0, width: datePicker.width, height: 250.0)
        self.datePicker = datePicker
        birthField.inputView = datePicker
        birthField.reloadInputViews()
    }
    
    private func showGenderSelectView() {
        genderField.resignFirstResponder()
        let genderPicker = LGAlertView(title: nil, message: nil, style: .actionSheet, buttonTitles: ["Male", "Female"], cancelButtonTitle: nil, destructiveButtonTitle: nil, delegate: self)
        genderPicker.showAnimated()
    }
    
    private func validatePassword() -> Bool {
        let pwd = passwordField.text!
        let confirmPwd = retypePasswordField.text!
        if pwd != confirmPwd {
            SVProgressHUD.showError(withStatus: "两次密码输入不一致！")
            return false
        }
        return true
    }
    
    private func setAllTextFieldReturnType(type:UIReturnKeyType) {
        findTextfield {
            $0.returnKeyType = type
        }
    }
    
    private func findTextfield(complete:((_ textfield:UITextField) -> ())?) {
        for subview in view.subviews[0].subviews {
            if subview.isKind(of: UITextField.self) {
                let textField = subview as! UITextField
                if (complete != nil) {
                    complete!(textField)
                }
            }
        }
    }
    
    private func onTextChanged() {
        for tf in self.textfields! {
            let text = tf.text! as NSString
            if text.length == 0 && tf.tag != -1 {
                fullFilled = false
                break
            } else {
                fullFilled = true
            }
        }
        print(fullFilled)
        if fullFilled == false {
            setAllTextFieldReturnType(type: .next)
        } else {
            setAllTextFieldReturnType(type: .done)
        }
    }
    
    //MARK: -
    func alertView(_ alertView: LGAlertView, buttonPressedWithTitle title: String?, index: UInt) {
        genderField.text = title!
    }
    
}
