//
//  XBSquareButton.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/4.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit

class XBSquareButton: UIButton {
    
    let subTitleLabel = UILabel()
    
    var subTitleRatioToImageView:CGFloat = 0.38*UIRate {
        didSet {
            subTitleLabel.height = imageView!.height * (1-subTitleRatioToImageView)
            subTitleLabel.top = imageView!.height * subTitleRatioToImageView
        }
    }
    
    //重写enabled
    override var isEnabled: Bool {
        set {
            super.isEnabled = newValue
            if super.isEnabled {
                //self.backgroundColor = UIColorHex("0x77716C", 1.0)
            } else {
                //self.backgroundColor = RGBA(r: 174, g: 178, b: 179, a: 1)
                //self.setTitleColor(UIColor.darkGray, for: .normal)
            }
        }
        get {
            return super.isEnabled
        }
    }
    
    ///从代码加载
    override init(frame: CGRect) {
        super.init(frame:frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.textAlignment = .center
        self.setTitleColor(XB_DARK_TEXT, for: .normal)
        commonInit()
    }
    
    ///从storyboard里面加载
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        subTitleLabel.textColor = UIColor.white
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .center
        
        let imageViewH = bounds.height * 2 / 3 * UIRate
        subTitleLabel.width = bounds.width
        subTitleLabel.height = imageViewH * (1-subTitleRatioToImageView)
        subTitleLabel.top = imageViewH * subTitleRatioToImageView
        addSubview(subTitleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView!.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 2*bounds.height/3)
        titleLabel?.sizeToFit()
        titleLabel!.centerX = self.width * 0.5
        titleLabel!.frame.origin.y = imageView!.bottom + 8
        subTitleLabel.centerX = titleLabel!.centerX
    }

    
}
