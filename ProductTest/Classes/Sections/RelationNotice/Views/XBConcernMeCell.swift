//
//  XBConcernMeCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/16.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBConcernMeCell: XBRelationConcernCell {
    
    var cancelConcernButton:UIButton!
    var clickCancelButton:((XBUser)->())?

    override func setup() {
        super.setup()
        cancelConcernButton = pileButton(color: UIColor.green, selector: #selector(clickCancelConcern(_:)), title: "CancelConcern")
        contentView.addSubview(cancelConcernButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cancelConcernButton.right = width - 10
        cancelConcernButton.centerY = height * 0.5
    }
    
    //MARK: - Action
    @objc private func clickCancelConcern(_ btn:UIButton) {
        if clickCancelButton != nil {
            clickCancelButton!(model.user!)
        }
    }
}
