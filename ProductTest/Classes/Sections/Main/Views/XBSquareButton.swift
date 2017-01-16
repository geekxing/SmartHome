//
//  XBSquareButton.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/4.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit

class XBSquareButton: UIButton {
    
    override var isEnabled: Bool {
        set {
            super.isEnabled = newValue
            if super.isEnabled {
                self.backgroundColor = SMRandomColor()
            } else {
                self.backgroundColor = UIColor.lightGray
                self.setTitleColor(UIColor.darkGray, for: .normal)
            }
        }
        get {
            return super.isEnabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.textAlignment = .center
        self.backgroundColor = SMRandomColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView!.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 2*bounds.height/3)
        titleLabel!.center = imageView!.center
        titleLabel!.frame.origin.y = imageView!.frame.origin.y+imageView!.bounds.height
        titleLabel!.frame = CGRect(x: 0, y: imageView!.frame.origin.y+imageView!.bounds.height, width: self.bounds.width, height: self.bounds.height - titleLabel!.frame.origin.y)
    }

    
}
