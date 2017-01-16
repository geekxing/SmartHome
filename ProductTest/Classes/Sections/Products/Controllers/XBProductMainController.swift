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
        self.mainView.clickSquare = {[weak self] in
            let title = $0.titleLabel?.text
            switch $0.tag {
            case 2: self!.addDevice()
            default: break
            }
            self?.view.makeToast(title!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (mainView as! XBProductMainView).toggleFunctionEnabled(sn: loginUser?.type1sn)
    }
    
    private func addDevice() {
        let vc = XBAddDeviceViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
