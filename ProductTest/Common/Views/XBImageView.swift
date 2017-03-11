//
//  XBImageView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/1.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBImageView: UIImageView {
    
    var clipPath = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.isGeometryFlipped = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.isGeometryFlipped = true
    }
    
}
