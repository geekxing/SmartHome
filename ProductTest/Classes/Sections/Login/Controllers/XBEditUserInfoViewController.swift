
//
//  XBEditUserInfoViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/14.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import IQKeyboardManagerSwift
import FTPopOverMenu_Swift
import LGAlertView
import Toast_Swift
import SVProgressHUD

class XBEditUserInfoViewController: UIViewController, UITextFieldDelegate, LGAlertViewDelegate, XBPhotoPickerManagerDelegate {
    
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
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var pickAvatarButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var loginUser:XBUser?
    var fullFilled:Bool = false
    var datePicker:UIDatePicker? = nil
    var photoManager:XBPhotoPickerManager?
    var avatarImage:UIImage?
    
    lazy var textfields:[UITextField]? = {
        return []
    }()
    
    init() {
        super.init(nibName: "XBEditUserInfoViewController", bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "XBEditUserInfoViewController", bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.setStatusBarStyle(.default, animated:false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        scrollView.contentSize = CGSize(width: 0, height: backgroundView.height + CGFloat( margin * 2))
        self.automaticallyAdjustsScrollViewInsets = false
        photoManager = XBPhotoPickerManager.shared
        photoManager?.delegate = self
        
        middleNameField.tag = -1
        addressField.tag = -1
        pSerialNoField.tag = -1
        
        findTextfield {[weak self] in
            self!.textfields?.append($0)
        }

        usernameTextField.text = loginUser?.Email
        firstnameField.text = loginUser?.firstName!
        middleNameField.text = loginUser?.middleName
        lastnameField.text =  loginUser?.lastName!
        birthField.text = loginUser?.yearOfBirth
        genderField.text = loginUser?.gender
        phoneNumberField.text = loginUser?.phoneNumber
        addressField.text = loginUser?.address
        usernameTextField.isEnabled = false
        usernameTextField.backgroundColor = UIColor.lightGray
        usernameTextField.textColor = UIColor.darkGray
        avatarView.sd_setImage(with: URL.init(string: XBImagePrefix + loginUser!.image!), placeholderImage: UIImage(named: "avatar_user")?.circleImage())
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
        if (!fullFilled) {
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
        ]
        
        let url = baseRequestUrl + "login/modify"
        
        SVProgressHUD.show()
        
        Alamofire.upload(
            multipartFormData: {[weak self] multipartFormData in
                if let uploadImage = self?.avatarImage {
                    if let imageData = UIImagePNGRepresentation(uploadImage)?.base64EncodedData(options: .lineLength64Characters) {
                        //let filePath = XBFileLocationHelper.getAppDocumentPath() + "/avatar.txt"
                        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                        url = url?.appendingPathComponent("avatar.png")
                        try! imageData.write(to: url!)
                        multipartFormData.append(url!, withName: "header")
                    }
                }
                //add bodypart
                for (key , value) in params {
                    assert(value is String)
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
        },
            to: url,
            encodingCompletion: {[weak self] encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            let message = json[Message].stringValue
                            if json[Code].intValue == updateInfo {
                                SVProgressHUD.showSuccess(withStatus: message)
                                self?.checkUserInfo()
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: { [weak self] in
                                    self?.back(self!.backButton)
                                })
                            } else {
                                SVProgressHUD.showError(withStatus: message)
                            }
                            break
                        default:break
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
    func checkUserInfo() {
        
        XBOperateUtils.shared.login(email: usernameTextField.text!, token: passwordField.text!, success: { (result) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0, execute: {
                let nav = XBNavigationController(rootViewController: XBMainViewController())
                UIApplication.shared.keyWindow?.rootViewController = nav
            })
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
        
    }
    
    @IBAction func pickAvatar(_ sender: UIButton) {
        photoManager?.pickIn(vc: self)
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
    
    //MARK: - XBPhotoPickerManagerDelegate
    func imagePickerDidFinishPickImage(image: UIImage) {
        avatarImage = image.resizeImage(newSize: avatarView.frame.size)
        avatarView.image = avatarImage?.circleImage()
    }
    
    //MARK: - LGAlertViewDelegate
    func alertView(_ alertView: LGAlertView, buttonPressedWithTitle title: String?, index: UInt) {
        genderField.text = title!
    }
    
}
