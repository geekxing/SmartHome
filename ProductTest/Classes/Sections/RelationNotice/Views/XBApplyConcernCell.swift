//
//  XBApplyConcernCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/16.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBApplyConcernCell: XBRelationConcernCell {
    
    static let maxNameLen = CGFloat(60.0*UIRate)
    static let maxEmailLen = CGFloat(80.0*UIRate)
    
    private var agreeButton:UIButton!
    private var refuseButton:UIButton!
    
    var clickAgreeButton:((XBUser) -> ())?
    var clickRefuseButton:((XBUser) -> ())?
    
    override func setup() {
        super.setup()
        agreeButton = pileButton(selector: #selector(clickAgree(_:)), title: "批准")
        refuseButton = pileButton(selector: #selector(clickRefuse(_:)), title: "拒绝")
        shadowLineview.isHidden = false
        contentView.addSubview(agreeButton)
        contentView.addSubview(refuseButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.width = XBApplyConcernCell.maxNameLen
        nameLabel.centerY = height * 0.5
        nameLabel.left = avatarView.right + 8*UIRate
        emailLabel.width = XBApplyConcernCell.maxEmailLen
        emailLabel.centerY = height * 0.5
        emailLabel.left = nameLabel.right
        refuseButton.right = width - 25*UIRate
        refuseButton.centerY = height * 0.5
        agreeButton.right = refuseButton.left - 8*UIRate
        agreeButton.centerY = height * 0.5
    }
    
    //MARK: - Action
    @objc private func clickAgree(_ btn:UIButton) {
        if clickAgreeButton != nil {
            clickAgreeButton!(model.user!)
        }
    }
    
    @objc private func clickRefuse(_ btn:UIButton) {
        if clickRefuseButton != nil {
            clickRefuseButton!(model.user!)
        }
    }

}
