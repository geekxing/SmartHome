//
//  UIToolsManager.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/20.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import LGAlertView

class UIToolsManager: NSObject {
    
    class func showAlert(_ titles:[String], delegate:LGAlertViewDelegate?) {
        
        let alertView = LGAlertView(title: "确定申请？", message: nil, style: .alert, buttonTitles: titles, cancelButtonTitle: "取消", destructiveButtonTitle: nil, delegate: delegate)
        
        alertView.coverColor = UIColor.init(white: 1.0, alpha: 0.25)
        alertView.coverBlurEffect = UIBlurEffect.init(style: .extraLight)
        alertView.coverAlpha = 0.85;
        alertView.layerShadowColor = UIColor.init(white: 0.0, alpha: 0.3)
        alertView.layerShadowRadius = 4.0;
        alertView.layerShadowOpacity = 1.0;
        alertView.layerCornerRadius = 0.0;
        alertView.layerBorderWidth = 2.0;
        alertView.width = min(SCREEN_WIDTH, SCREEN_HEIGHT)
        alertView.layerBorderColor = UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        alertView.backgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
        alertView.separatorsColor = nil;
        alertView.show(animated: true, completionHandler: nil)
    }

}
