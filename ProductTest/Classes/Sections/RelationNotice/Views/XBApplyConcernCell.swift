//
//  XBApplyConcernCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/16.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBApplyConcernCell: XBRelationConcernCell {
    
    private var agreeButton:UIButton!
    private var refuseButton:UIButton!
    override var model:XBRelationConcernModel! {
        didSet {
            avatarView.image = nil
        }
    }
    
    var clickAgreeButton:((XBUser) -> ())?
    var clickRefuseButton:((XBUser) -> ())?
    
    override func setup() {
        super.setup()
        agreeButton = pileButton(color: UIColor.green, selector: #selector(clickAgree(_:)), title: "Agree")
        refuseButton = pileButton(color: UIColor.white, selector: #selector(clickRefuse(_:)), title: "Refuse")
        contentView.addSubview(agreeButton)
        contentView.addSubview(refuseButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refuseButton.right = width - 10
        refuseButton.centerY = height * 0.5
        agreeButton.right = refuseButton.left - 10
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
