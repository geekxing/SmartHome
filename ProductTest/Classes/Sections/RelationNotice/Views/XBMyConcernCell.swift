//
//  XBMyConcernCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/16.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBMyConcernCell: XBConcernMeCell {
    
    var arrowButton:UIButton!
    
    override var model:XBRelationConcernModel! {
        didSet {
            arrowButton.isSelected = self.model.open
            for view in productViews {
                view.isHidden = !model.open
            }
        }
    }
    
    private let bedView = XBCheckProductView.init("智能床垫")
    private let pillowView = XBCheckProductView.init("智能枕")
    private let ringView = XBCheckProductView.init("智能手环")
    
    var productViews:[XBCheckProductView]!
    
    var clickArrowButton:(()->())?
    
    override func setup() {
        super.setup()
        
        arrowButton = UIButton.init(image: UIImage(named:"arrowDown"), backImage: nil, color: nil, target: self, sel: #selector(clickArrow(_:)), title: "")
        arrowButton.setImage(UIImage(named:"arrowUp"), for: .selected)
        productViews = [bedView, pillowView, ringView]
        for view in productViews {
            view.isHidden = true
            contentView.addSubview(view)
        }
        contentView.addSubview(arrowButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arrowButton.width = 22;
        arrowButton.height = 22;
        arrowButton.left = 2
        arrowButton.centerY = avatarView.centerY;
        for (index, view) in productViews.enumerated() {
            view.frame = CGRect(x: self.nameLabel.left, y: 71 + CGFloat(index*40), width: self.cancelConcernButton.left-self.nameLabel.left, height: 20)
        }
    }
    
    //MARK: - Action
    @objc private func clickArrow(_ btn:UIButton) {
        self.model.open = !self.model.open
        if self.clickArrowButton != nil {
            self.clickArrowButton!()
        }
    }

}
