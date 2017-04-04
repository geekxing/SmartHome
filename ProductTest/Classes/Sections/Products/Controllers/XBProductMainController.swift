//
//  XBProductMainController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/15.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBProductMainController: XBMainViewController {
    
    override func setupMainView() {
        
        mainView = XBProductMainView(frame: view.bounds)
        
        let enumerate = mainView.squareBtns.enumerated()
        for (_, square) in enumerate {
            square.setTitleColor(UIColor.white, for: .normal)
            square.titleLabel?.font = UIFontSize(size: 13.5)
        }
        self.mainView.clickSquare = {[weak self] in
            let title = $0.titleLabel?.text
            switch $0.tag {
            case 0: self!.realTimeData()
            case 1: self!.checkHealCare()
            case 2: self!.addDevice()
            case 3: self!.deleteDevice()
            default: break
            }
            self?.view.makeToast(title!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = nil
        (mainView as! XBProductMainView).toggleFunctionEnabled(sn: loginUser?.type1sn)
    }
    
    //MARK: - Notification
    @objc override func onUserInfoUpdated(notification:Notification) {
        super.onUserInfoUpdated(notification: notification)
        (mainView as! XBProductMainView).toggleFunctionEnabled(sn: loginUser?.type1sn)
    }
    
    //MARK: - Private
    
    override func setupNaviItem() {
    }
    
    private func realTimeData() {
        let vc = XBRealDataViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func checkHealCare() {
        let vc = XBHealthCareViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addDevice() {
        let vc = XBAddDeviceViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func deleteDevice() {
        let vc = XBDeleteDeviceViewController()
        vc.loginUser = self.loginUser!
        navigationController?.pushViewController(vc, animated: true)
    }

}
