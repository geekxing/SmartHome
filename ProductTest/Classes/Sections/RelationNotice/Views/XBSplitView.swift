//
//  XBSplitView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/20.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBSplitView: UIView {
    
    let buttonW = SCREEN_WIDTH/3
    static let buttonH = CGFloat(69.0)
    
    private var applyConcern:UIButton?
    private var myConcern:UIButton?
    private var concernMe:UIButton?
    
    private var previousButton:UIButton?
    
    var tapSplitButton:((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        
        applyConcern = setupButton(title: "关注申请")
        applyConcern?.tag = 0
        applyConcern?.isSelected = true
        myConcern = setupButton(title: "我的关注")
        myConcern?.tag = 1
        myConcern?.isSelected = false
        concernMe = setupButton(title: "关注我的")
        concernMe?.tag = 2
        concernMe?.isSelected = false
        
        addSubview(applyConcern!)
        addSubview(myConcern!)
        addSubview(concernMe!)
        
        previousButton = applyConcern
        
    }
    
    private func setupButton(title:String!) -> UIButton {
        
        let button = UIButton.init(image: nil, backImage: UIImage.imageWith(UIColor.lightGray), color: nil, target: self, sel: #selector(tapBtn(_:)), title: title)
        button.titleLabel?.font = UIFontSize(size: 20)
        button.setBackgroundImage(UIImage.imageWith(UIColor.white), for: .selected)
        button.setBackgroundImage(UIImage.imageWith(UIColor.lightGray), for: .highlighted)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColorHex("333333", 1.0), for: .selected)
        
        return button
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyConcern?.frame = CGRect(x: 0, y: 0, width: buttonW, height: XBSplitView.buttonH)
        myConcern?.frame = CGRect(x: applyConcern!.right, y: 0, width: buttonW, height: XBSplitView.buttonH)
        concernMe?.frame = CGRect(x: myConcern!.right, y: 0, width: buttonW, height: XBSplitView.buttonH)
    }
    
    //MARK: - Private
    @objc private func tapBtn(_ button:UIButton) {
        
        previousButton?.isSelected = false
        button.isSelected = true
        previousButton = button
        if self.tapSplitButton != nil {
            self.tapSplitButton!(button.tag)
        }
    }

}
