//
//  XBMainViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/30.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class XBMainViewController: UIViewController {
    
    var mainView:XBMainView!
    var loginUser:XBUser?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = RGBA(r: 127, g: 196, b: 98, a: 1)

        setupMainView()
        mainView.tapAvatar = { [weak self](user) in
            let editUserVC = XBEditUserInfoViewController()
            editUserVC.loginUser = user
            self?.navigationController?.pushViewController(editUserVC, animated: true)
        }
        view.addSubview(mainView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUserInfoUpdated(notification:)), name: NSNotification.Name(rawValue: XBUserInfoHasChangedNotification), object: nil)
    }
    
    public func setupMainView() {
        mainView = XBMainView(frame: view.bounds)
        self.mainView.clickSquare = {[weak self] in
            let title = $0.titleLabel?.text
            switch $0.tag {
            case 0: self!.smartMattress()
            case 3: self!.relationConcern()
            default: break
            }
            self?.view.makeToast(title!)
        }
    }
    
    @objc private func onUserInfoUpdated(notification:Notification) {
        let uid = notification.object as! String
        let currentAccount = XBUserManager.shared.currentAccount()!
        guard currentAccount == uid else { return }
        if let user = XBUserManager.shared.user(uid: uid) {
            mainView.currentUser = user
        }
    }
    
    private func smartMattress() {
        let vc = XBProductMainController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func relationConcern() {
        let vc = XBRelationNoticeController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
