//
//  XBRealDetailTableCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/23.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBRealDetailTableCell: XBRealDataTableCell {
    
    override var event:Int {
        didSet {
           realtimeState.event = event
        }
    }
    
    var offline:XBSquareButton!
    var onBed:XBSquareButton!
    var motivate:XBSquareButton!
    var noBody:XBSquareButton!
    var realtimeState:XBDisplayRealStateView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = CGFloat(20)
        noBody.top = margin
        noBody.right = width - margin
        motivate.top = margin
        motivate.right = noBody.right - UIRate*50
        onBed.top = margin
        onBed.right = motivate.right - UIRate*50
        offline.top = margin
        offline.right = onBed.right - UIRate*50
        
        realtimeState.left = UIRate * 33
        realtimeState.top = onBed.bottom + 30
        realtimeState.width = width - UIRate * 66
        realtimeState.height = 150
    }
    
    override func setup() {
        super.setup()
        self.shouldEnableEcgDisplay = false
        offline = self.pileButton(#imageLiteral(resourceName: "dot2"), title: "离线")
        onBed = self.pileButton(#imageLiteral(resourceName: "onBed"), title: "在床")
        motivate = self.pileButton(#imageLiteral(resourceName: "motivate"), title: "体动")
        noBody = self.pileButton(#imageLiteral(resourceName: "nobody"), title: "无人")
        realtimeState = XBDisplayRealStateView(frame: CGRect.zero)
        addSubview(realtimeState)
    }
    
    
    private func pileButton(_ img:UIImage, title:String) -> XBSquareButton {
        let btn = XBSquareButton()
        btn.setImage(img, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(XB_DARK_TEXT, for: .normal)
        btn.width = 30
        btn.height = 45
        contentView.addSubview(btn)
        return btn
    }


}
