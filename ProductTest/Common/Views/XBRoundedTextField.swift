//
//  XBRoundedTextField.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/20.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBRoundedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColorHex("595757", 1.0).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.height * 0.5
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 16, y: 0, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 16, y: 0, width: bounds.width, height: bounds.height)
    }

}
