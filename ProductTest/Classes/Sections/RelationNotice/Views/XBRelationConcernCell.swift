//
//  XBRelationConcernCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/16.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBRelationConcernCell: UITableViewCell {
    
    var avatarView:UIImageView!
    var nameLabel:UILabel!
    var emailLabel:UILabel!
    var shadowLineview:UIImageView!
    
    var model:XBRelationConcernModel! {
        didSet {
            let user = model.user!
            avatarView.sd_setImage(with: URL.init(string: XBImagePrefix + user.image!), placeholderImage: UIImage(named: "avatar_user")?.circleImage())
            var name = ""
            if let fullName = user.Name {
                name = fullName
            }
            nameLabel.text = name
            nameLabel.sizeToFit()
            emailLabel.text = user.Email!
            emailLabel.sizeToFit()
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
        avatarView = UIImageView()
        avatarView.isUserInteractionEnabled = true
        nameLabel = UILabel()
        nameLabel.font = UIFontSize(size: 16)
        nameLabel.textColor = UIColorHex("333333", 1.0)
        emailLabel = UILabel()
        emailLabel.font = UIFontSize(size: 11)
        emailLabel.textColor = UIColorHex("595757", 1.0)
        shadowLineview = UIImageView(image: UIImage(named: "horizontalShadow"))
        shadowLineview.isHidden = true
        contentView.addSubview(avatarView!)
        contentView.addSubview(nameLabel!)
        contentView.addSubview(emailLabel!)
        contentView.addSubview(shadowLineview!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nameLabelToHeaderMargin = 0.0
        if (avatarView.image != nil) {
            avatarView.width = 54*UIRate
            avatarView.height = 54*UIRate
            nameLabelToHeaderMargin = 8
        } else {
            avatarView.sizeThatFits(CGSize.zero)
            nameLabelToHeaderMargin = 0
        }
        avatarView.x = 33*UIRate
        avatarView.centerY = height * 0.5
        
        nameLabel.left = avatarView!.right + CGFloat(nameLabelToHeaderMargin)
        nameLabel.bottom = avatarView.height * 0.5
        
        shadowLineview.width = self.width
        shadowLineview.bottom = self.bottom
        shadowLineview.left = 0
        
    }
    
    func pileButton(selector:Selector, title:String) -> XBRoundedButton {
        let button = XBRoundedButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        button.sizeToFit()
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.width += 22
        button.height = 25
        return button
    }
    
}
