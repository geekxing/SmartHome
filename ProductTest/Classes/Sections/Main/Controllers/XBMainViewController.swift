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
    
    var loginUser:XBUser? {
        let currentAccount = XBUserManager.shared.currentAccount()!
        if let user = XBUserManager.shared.user(uid: currentAccount) {
            return user
        }
        return nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupMainView()
        mainView.tapAvatar = { [weak self](user) in
            let editUserVC = XBEditUserInfoViewController()
            editUserVC.loginUser = user
            self?.navigationController?.pushViewController(editUserVC, animated: true)
        }
        view.addSubview(mainView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUserInfoUpdated(notification:)), name: NSNotification.Name(rawValue: XBUserInfoHasChangedNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNaviItem()
    }
    
    public func setupMainView() {
        mainView = XBMainView(frame: view.bounds)
        self.mainView.clickSquare = {[weak self] in
            let title = $0.titleLabel?.text
            switch $0.tag {
            case 0: self!.smartMattress()
            case 3: self!.relationConcern()
            case 4: self!.productVersion()
            default: break
            }
            self?.view.makeToast(title!)
        }
    }
    
    //MARK: - Notification
    @objc func onUserInfoUpdated(notification:Notification) {
        let uid = notification.object as! String
        let currentAccount = XBUserManager.shared.currentAccount()!
        guard currentAccount == uid else { return }
        if let user = XBUserManager.shared.user(uid: uid) {
            mainView.currentUser = user
        }
    }
    
    //MARK: - Private
    
    private func setupNaviItem() {
        //        let backButton = UIButton.init(image: UIImage(named:"backButton"), color: nil, target: self, sel: #selector(back), title: "注销")
        //        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"settings"), style: .plain, target: self, action: #selector(settings))
    }
    
    @objc private func settings() {
        
    }
    
    @objc private func back() {
        navigationController!.popViewController(animated: true)
    }
    
    private func smartMattress() {
        let vc = XBProductMainController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func relationConcern() {
        let vc = XBRelationNoticeController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func productVersion() {
        let vc = XBProductVersionController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
