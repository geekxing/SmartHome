//
//  XBNavigationController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/23.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit

class XBNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        interactivePopGestureRecognizer?.delegate = self
    }

    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 && !viewController.isKind(of: XBLoginViewController.self) {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:UIImage(named:"backButton") , style: .plain, target: self, action:#selector(onGoBack))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func onGoBack() {
        popViewController(animated: true)
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count > 1
    }
}
