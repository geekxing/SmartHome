//
//  XBConcernMeCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/16.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBConcernMeCell: XBRelationConcernCell {
    
    static let maxNameLen = CGFloat(100.0*UIRate)
    static let maxEmailLen = CGFloat(150.0*UIRate)
    
    var cancelConcernButton:UIButton!
    var clickCancelButton:((XBUser)->())?

    override func setup() {
        super.setup()
        cancelConcernButton = UIButton.init(image: UIImage(named:"trashbin"), backImage: nil, color: nil, target: self, sel: #selector(clickCancelConcern(_:)), title: "")
        cancelConcernButton.sizeToFit()
        contentView.addSubview(cancelConcernButton)
        shadowLineview.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.top = 0;
        nameLabel.width = XBConcernMeCell.maxNameLen
        nameLabel.centerY = avatarView.centerY
        nameLabel.left = avatarView.right + 8*UIRate
        emailLabel.width = XBConcernMeCell.maxEmailLen
        emailLabel.centerY = avatarView.centerY
        emailLabel.left = nameLabel.right
        cancelConcernButton.right = width - 21
        cancelConcernButton.centerY = avatarView.centerY
    }
    
    //MARK: - Action
    @objc private func clickCancelConcern(_ btn:UIButton) {
        if clickCancelButton != nil {
            clickCancelButton!(model.user!)
        }
    }
}
