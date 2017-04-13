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
    var sn:String? {
        didSet {
            realTimeDataButton.isEnabled = sn != nil
            healCareButton.isEnabled = sn != nil
        }
    }
    private var realTimeDataButton:UIButton!
    private var healCareButton:UIButton!
    
    var clickRealTimeButton:(() -> ())?
    var clickHealthButton:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(_ name:String) {
        self.init()
        self.productLabel.text = name
    }
    
    private func setup() {
        productLabel = UILabel()
        productLabel.font = UIFont.boldSystemFont(ofSize: 14)
        productLabel.textColor = XB_DARK_TEXT
        realTimeDataButton = XBRoundedButton.init(selector: #selector(clickRealTime(_:)),target:self, title: "查看实时数据")
        healCareButton = XBRoundedButton.init(selector: #selector(clickHealCare(_:)),target:self, title: "查看健康档案")
        realTimeDataButton.isEnabled = false
        healCareButton.isEnabled = false
        addSubview(productLabel)
        addSubview(realTimeDataButton)
        addSubview(healCareButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        productLabel.sizeToFit()
        productLabel.left = 0
        productLabel.centerY = height * 0.5
        healCareButton.height = 20;
        healCareButton.right = width
        healCareButton.centerY = height * 0.5
        realTimeDataButton.height = 20;
        realTimeDataButton.right = healCareButton.left - 10
        realTimeDataButton.centerY = height * 0.5
    }
    
    //MARK: - Action
    @objc private func clickRealTime(_ btn:UIButton) {
        if clickRealTimeButton != nil {
            clickRealTimeButton!()
        }
        
    }
    
    @objc private func clickHealCare(_ btn:UIButton) {
        if clickHealthButton != nil {
            clickHealthButton!()
        }
    }
    
}
