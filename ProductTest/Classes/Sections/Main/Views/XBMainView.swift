//
//  XBMainView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/4.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import SDWebImage

class XBMainView: UIView {
    static let edgeMargin = 20.0
    static let interMargin = 10.0
    
    let btnColor = UIColor(white: 0/255.0, alpha: 0.2)
    
    var avatarView:UIImageView!
    var nameLabel:UILabel!
    var changeUserBtn:UIButton!
    var currentUser:XBUser = XBUser() {
        didSet {
            avatarView.sd_setImage(with: URL.init(string: XBImagePrefix + self.currentUser.image! ), placeholderImage: UIImage(named: "avatar_user"))
            let middleName = self.currentUser.middleName ?? ""
            nameLabel.text = currentUser.firstName+middleName+currentUser.lastName
            nameLabel.sizeToFit()
        }
    }
    
    var mainItems:[MainItemModel] {
        let btnTitles = ["智能床垫", "智能枕", "智能手环", "亲情关注", "产品升级", "名医生堂"]
        let itemEnables = [true, false, false, true, true, false]
        var array = [MainItemModel]()
        for i in 0..<6 {
            let mainitem = MainItemModel(image: "", title:btnTitles[i], enabled:itemEnables[i])
            array.append(mainitem)
        }
        return array
    }
    
    lazy var squareBtns:[XBSquareButton] = {[]}()
    
    var clickSquare:((UIButton) -> ())?
    var tapAvatar:((XBUser) -> ())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        setupUserPart()
        pileButton()
        let userMgr = XBUserManager.shared
        if let uid = userMgr.currentAccount() {
            if let user = userMgr.user(uid: uid) {
                self.currentUser = user
            }
        } else {
            print("无法获取登录用户信息！")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame.origin = CGPoint(x: avatarView.centerX - nameLabel.width/2, y: avatarView.bottom + 10)
    }
    
    private func setupUserPart() {
        avatarView = UIImageView(frame:CGRect(x: 0 ,y: 50, width: 100, height: 100))
        avatarView.centerX = self.centerX
        avatarView.layer.cornerRadius = avatarView.height/2
        avatarView.layer.masksToBounds = true
        avatarView.layer.shadowOffset = CGSize(width: 1, height: 1)
        avatarView.layer.shadowColor = UIColor.black.cgColor
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAvatar(tap:))))
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.white
        
        changeUserBtn = UIButton.init(image: UIImage(named: "changeUser"), color: btnColor, target: self, sel: #selector(changeUser), title: "切换\n用户")
        changeUserBtn.titleLabel?.numberOfLines = 2;
        changeUserBtn.width = 100
        changeUserBtn.height = 50
        changeUserBtn.centerX = self.width - 30
        changeUserBtn.top = avatarView.top + 4
        changeUserBtn.layer.cornerRadius = changeUserBtn.bounds.height/2
        changeUserBtn.imageView?.layer.masksToBounds = true
        changeUserBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        changeUserBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        addSubview(changeUserBtn)
        addSubview(avatarView)
        addSubview(nameLabel)
    }
    
    private func pileButton() {
        let maxColsCount = mainItems.count / 2
        
        for i in 0..<mainItems.count {
            let mainItem = self.mainItems[i]
            let btnW = btnWidth(numPerRow: maxColsCount)
            let btnH = CGFloat(120)
            var x = CGFloat(XBMainView.edgeMargin)
            x += CGFloat(i%maxColsCount)*(CGFloat(XBMainView.interMargin)+btnW)
            let square = XBSquareButton.init(image: UIImage(named: "placeholder"), color:nil, target: self, sel: #selector(click(btn:)), title:mainItem.title)
            if mainItem.enabled == false {
                square.isEnabled = mainItem.enabled
            }
            square.tag = i
            var y = CGFloat(0)
            if i < maxColsCount {
                y = center.y - CGFloat(XBMainView.edgeMargin/2.0) - btnH
            } else {
                y = center.y + CGFloat(XBMainView.edgeMargin/2.0)
            }
            square.frame = CGRect(x: x, y: y, width: btnW, height: btnH)
            self.squareBtns.append(square)
            addSubview(square)
        }
    }
    
    private func btnWidth(numPerRow:Int) -> CGFloat {
        return (bounds.width - CGFloat(2*XBMainView.edgeMargin) - CGFloat(Double((numPerRow-1))*XBMainView.interMargin))/CGFloat(numPerRow)
    }
    
    //MARK: - action
    @objc private func changeUser() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: XBNotificationLogout), object: nil)
    }
    
    @objc private func click(btn:UIButton) {
        if (clickSquare != nil) {
            clickSquare!(btn)
        }
    }
    
    @objc private func tapAvatar(tap:UITapGestureRecognizer) {
        if tapAvatar != nil {
            tapAvatar!(self.currentUser)
        }
    }
}
