//
//  XBCheckProductView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/25.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBCheckProductView: UIView {
    
    var productLabel:UILabel!
    private var realTimeDataButton:UIButton!
    private var healCareButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(_ name:String!) {
        self.init()
        self.productLabel.text = name
    }
    
    private func setup() {
        productLabel = UILabel()
        productLabel.font = UIFont.boldSystemFont(ofSize: 14)
        productLabel.textColor = UIColorHex("333333", 1.0)
        realTimeDataButton = XBRoundedButton.init(selector: #selector(clickRealTime(_:)),target:self, title: "查看实时数据")
        healCareButton = XBRoundedButton.init(selector: #selector(clickHealCare(_:)),target:self, title: "查看健康档案")
        addSubview(productLabel)
        addSubview(realTimeDataButton)
        addSubview(healCareButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        productLabel.sizeToFit()
        productLabel.left = 0
        productLabel.centerY = height * 0.5
        realTimeDataButton.height = 20;
        realTimeDataButton.left = floor(width/3) - 5
        realTimeDataButton.centerY = height * 0.5
        healCareButton.height = 20;
        healCareButton.left = floor(width*2/3) + 10
        healCareButton.centerY = height * 0.5
    }
    
    //MARK: - Action
    @objc private func clickRealTime(_ btn:UIButton) {
    }
    
    @objc private func clickHealCare(_ btn:UIButton) {
    }
    
}
