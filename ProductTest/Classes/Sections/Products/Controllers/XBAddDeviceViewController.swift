//
//  XBAddDeviceViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/15.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD

class XBAddDeviceViewController: UIViewController {
    
    @IBOutlet weak var snField: UITextField!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var typeSn:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        typeSn = oldText.replacingCharacters(in: range, with: string)
        let newText = typeSn! as NSString
        submitButton.isEnabled = newText.length != 0
        return true
    }
    
    @IBAction func beginScan(_ sender: UIButton) {
        let qrVC = XBQRCodeScanViewController()
        navigationController?.pushViewController(qrVC, animated: true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }

}
