//
//  XBRoundedButton.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/20.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBRoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        
        self.setBackgroundImage(UIImage.imageWith(RGBA(r: 136, g: 132, b: 128, a: 1)), for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.height * 0.5
    }
    
    
}
