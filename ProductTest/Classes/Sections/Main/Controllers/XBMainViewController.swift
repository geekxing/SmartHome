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
import SVProgressHUD
import SwiftyJSON

class XBMainViewController: XBBaseViewController {
    
    override var naviBackgroundImage: UIImage? {
        return UIImage(named: "bigPublicHeader")
    }
    
    var mainView:XBMainView!
    var originBackButton:UIBarButtonItem?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupMainView()
        setupNaviItem()
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
        if self.isMember(of: XBMainViewController.self) {
            //登录主页面后禁止侧滑手势，需要点击左上角“注销”按钮退出！
            (self.navigationController! as! XBNavigationController).shouldPopBlock = {}
        }
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
    
    func setupNaviItem() {
        self.originBackButton = self.navigationItem.leftBarButtonItem
        let backButton = UIButton(image: #imageLiteral(resourceName: "backButton"), backImage: nil, color: nil, target: self, sel:  #selector(back), title: "注销")
        backButton.setTitleColor(XB_DARK_TEXT, for: .normal)
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
        backButton.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"settings"), style: .plain, target: self, action: #selector(settings))
        
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

    @objc private func settings() {
        
    }
    
    @objc private func back() {
        
        let params:Dictionary = ["token":XBLoginManager.shared.currentLoginData!.token]
        
        XBNetworking.share.postWithPath(path: LOGOUT, paras: params,
                                        success: {[weak self]result in
                                            let json:JSON = result as! JSON
                                            let message = json[Message].stringValue
                                            if json[Code].intValue == 1 {
                                                let current = XBLoginManager.shared.currentLoginData
                                                current?.password = ""
                                                current?.token = ""
                                                XBLoginManager.shared.currentLoginData = current
                                                self!.navigationController!.popViewController(animated: true)
                                                SVProgressHUD.showSuccess(withStatus: message)
                                            } else {
                                                SVProgressHUD.showError(withStatus: message)
                                            }
            }, failure: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
        })
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
