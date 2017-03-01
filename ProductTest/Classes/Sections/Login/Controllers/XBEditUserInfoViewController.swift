
//
//  XBEditUserInfoViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/14.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift
import Toast_Swift
import SVProgressHUD
import DropDown

class XBEditUserInfoViewController: UIViewController, UITextFieldDelegate, XBPhotoPickerManagerDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var usernameTextField: XBTextField!
    @IBOutlet weak var firstnameField: XBTextField!
    @IBOutlet weak var middleNameField: XBTextField!
    @IBOutlet weak var lastnameField: XBTextField!
    @IBOutlet weak var birthField: XBTextField!
    @IBOutlet weak var birthButton: UIButton!
    @IBOutlet weak var genderField: XBTextField!
    @IBOutlet weak var genderButton: XBTextField!
    @IBOutlet weak var phoneNumberField: XBTextField!
    @IBOutlet weak var addressField: XBTextField!
    @IBOutlet weak var passwordField: XBTextField!
    @IBOutlet weak var retypePasswordField: XBTextField!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var pickAvatarButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let chooseGenderDropDown = DropDown()
    
    var loginUser:XBUser?
    private var fullFilled:Bool = true
    private var photoManager:XBPhotoPickerManager?
    private var avatarImage:UIImage?
    
    lazy var textfields:[UITextField]? = {
        return []
    }()
    
    lazy var dateFormatter:DateFormatter? = {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "dd/MM/yyyy"
        return dateFmt
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
        
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.contentSize = CGSize(width: 0, height: backgroundView.top + backgroundView.height + CGFloat(71))
        
        photoManager = XBPhotoPickerManager.shared
        photoManager?.delegate = self
        
        setupDropDown()
        setupTextField()
        setupAvatar()
        
        backButton.layer.cornerRadius = backButton.height * 0.5
        submitButton.layer.cornerRadius = submitButton.height * 0.5
        avatarView.layer.cornerRadius = avatarView.height * 0.5
        avatarView.layer.masksToBounds = true
    }
    
    //MARK: - Setup
    private func setupTextField() {
        middleNameField.tag = -1
        addressField.tag = -1
        
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
        passwordField.text = loginUser?.password
        retypePasswordField.text = loginUser?.password
        
        for tf in self.textfields! {
            if tf.text != "" {
                tf.textColor = UIColorHex("8a847f", 1.0)
            }
        }
        
        
        usernameTextField.isEnabled = false
    }
    
    private func setupAvatar() {
        avatarView.sd_setImage(with: URL.init(string: XBImagePrefix + loginUser!.image!), placeholderImage: UIImage(named: "avatar_user")?.circleImage())
        avatarView.isUserInteractionEnabled = true
        let tapAvatarGR = UITapGestureRecognizer.init(target: self, action: #selector(pickAvatar(_:)))
        avatarView.addGestureRecognizer(tapAvatarGR)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.textColor = UIColorHex("333333", 1.0)
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

        let boundary = "Boundary+V2ymHFg03ehbqgZCaKO6jy"
        
        let params:Dictionary = [
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
        
        // create request
        var request = URLRequest(url: URL.init(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        // post body
        var body = Data()
        
        // add params (all params are strings)
        let paramsDict = params as NSDictionary
        
        paramsDict.enumerateKeysAndObjects({ (key, obj, stop) in
            var fieldString = "--\(boundary)\r\n"
            fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            fieldString += "\(obj)\r\n"
            body.append(fieldString.data(using: .utf8)!)
        })
        
        // add image data
        if let uploadImage = self.avatarImage {
            if let imageData = UIImageJPEGRepresentation(uploadImage, 1.0) {
                //let filePath = XBFileLocationHelper.getAppDocumentPath() + "/avatar.txt"
                var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                url = url?.appendingPathComponent("avatar.png")
                try! imageData.write(to: url!)
                
                var imageString = "--\(boundary)\r\n"
                imageString +=  "Content-Disposition: form-data; name=\"header\"; filename=\"image.jpg\"\r\n"
                imageString += "Content-Type: image/jpeg\r\n"
                imageString += "Content-Transfer-Encoding: binary\r\n\r\n"
                
                body.append(imageString.data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
                body.append("--\(boundary)--\r\n".data(using: .utf8)!)
                
            }
        }
        
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = false
        
        // setting the body of the post to the reqeust
        request.httpBody = body
        
        // set the content-length
        request.setValue("\((body as NSData).length)", forHTTPHeaderField: "Content-Length")
        
        // set Content-Type in HTTP header
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let bodyString = String.init(data: body, encoding: .utf8)
        print("\(bodyString)")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {[weak self] (data, response, error) in
            print("\(data),\(response),\(error)")
            self!.checkUserInfo()
        })
        
        dataTask.resume()
        
    }
    
    func checkUserInfo() {
        
        XBOperateUtils.shared.login(email: usernameTextField.text!, token: passwordField.text!, success: {[weak self] (result) in
            self!.navigationController!.popViewController(animated: true)
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
    
    @IBAction func fillBirthday(_ sender: UIButton) {
        birthField.becomeFirstResponder()
        showCalendar()
    }
    
    //MARK: - Private
    private func showCalendar() {
        let date = self.dateFormatter!.date(from: loginUser!.yearOfBirth)
        datePicker!.date = date!
        birthField.inputView = datePicker
        birthField.reloadInputViews()
    }
    
    private func showGenderSelectView() {
        genderField.resignFirstResponder()
        chooseGenderDropDown.show()
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
        for subview in view.subviews[2].subviews {
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
    
    
}

extension XBEditUserInfoViewController {
    
    func setupDropDown() {
        setupChooseGenderDropDown()
    }
    
    private func setupChooseGenderDropDown() {
        configDropDown(chooseGenderDropDown, ["Male", "Female"], genderField)
    }
    
    private func configDropDown(_ dropDown:DropDown, _ datasource:Array<String>, _ anchorField:UITextField) {
        
        dropDown.anchorView = anchorField
        dropDown.bottomOffset = CGPoint(x: 0, y: anchorField.bounds.height)
        
        dropDown.dataSource = datasource
        
        dropDown.selectionAction = { (index, item) in
            anchorField.text = item
        }
        
        dropDown.dismissMode = .onTap
        dropDown.direction = .any
    
    }
    
}
