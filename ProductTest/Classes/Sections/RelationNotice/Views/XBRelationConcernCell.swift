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
    var model:XBRelationConcernModel! {
        didSet {
            let user = model.user!
            avatarView.sd_setImage(with: URL.init(string: XBImagePrefix + user.image!), placeholderImage: UIImage(named: "avatar_user"))
            var name = ""
            if let fullName = user.fullName {
                name = fullName
            }
            nameLabel.text = user.Email! + " " + name
            nameLabel.sizeToFit()
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
        contentView.addSubview(avatarView!)
        contentView.addSubview(nameLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nameLabelToHeaderMargin = 0.0
        if (avatarView.image != nil) {
            avatarView.width = 40
            avatarView.height = 40
            nameLabelToHeaderMargin = 10
        } else {
            avatarView.sizeThatFits(CGSize.zero)
        }
        avatarView.x = 15
        avatarView.centerY = height * 0.5
        
        nameLabel.left = avatarView!.right + CGFloat(nameLabelToHeaderMargin)
        nameLabel.centerY = height * 0.5
    }
    
    func pileButton(color:UIColor, selector:Selector, title:String) -> UIButton {
        let button = UIButton.init(image: nil, color: color, target: self, sel: selector, title: title)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFontSize(size: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        button.sizeToFit()
        button.width = 60
        return button
    }
    
}
