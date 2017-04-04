//
//  XBMyPurchaseTableCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/25.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBMyPurchaseTableCell: UITableViewCell {
    
    private var proNameLabel:UILabel!
    private var vipLabel:UILabel!
    private var purchaseButton:XBRoundedButton!
    
    var model:XBProductModel? {
        didSet {
            
            proNameLabel.text = model?.productName
            proNameLabel.sizeToFit()
            vipLabel.text = model?.level == "" ? "普通用户" : "会员"
            vipLabel.sizeToFit()
            purchaseButton.setTitle(model?.deadline != "" ? "续费" : "购买", for: .normal)
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        proNameLabel = UILabel()
        proNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        proNameLabel.textColor = XB_DARK_TEXT
        vipLabel = UILabel()
        vipLabel.font = UIFont.boldSystemFont(ofSize: 14)
        vipLabel.textColor = UIColorHex("8a847f", 1.0)
        purchaseButton = XBRoundedButton.init(selector: #selector(purchase(_:)), target: self, font:19, title: "续费")
        addSubview(proNameLabel)
        addSubview(vipLabel)
        addSubview(purchaseButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        proNameLabel.left = 33
        proNameLabel.centerY = height * 0.5
        
        let label = UILabel()
        label.font = proNameLabel.font
        label.text = "智能手环"
        label.sizeToFit()
        label.left = proNameLabel.left
        
        vipLabel.left = label.right+17
        vipLabel.bottom = proNameLabel.bottom-1
        
        purchaseButton.height = 35
        purchaseButton.width = 77
        purchaseButton.right = width - 33
        purchaseButton.centerY = height * 0.5
    }
    
    //MARK: - Private
    @objc private func purchase(_ btn:UIButton) {
        
    }
    
    
}
