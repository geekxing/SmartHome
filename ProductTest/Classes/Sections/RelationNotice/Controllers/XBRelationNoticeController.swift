//
//  XBRelationNoticeController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/15.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import LGAlertView
import Toast_Swift

class XBRelationNoticeController: UIViewController {
    
    private var loginUser:XBUser!
    private var naviBackground:UIImageView!
    private var titleLabel:UILabel!
    private var splitView:XBSplitView!
    
    private var currentIndex:Int = -1;
    var tableGroups:[XBTableGroupItem] = []
    private var childViews:[UIView] = []
    
    private var applyConcernVC:XBApplyConcernViewController!
    private var concernMeVC:XBConcernMeViewController!
    private var myConcernMeVC:XBMyConcernViewController!
    private var scollView:UIScrollView!
    
    fileprivate let StatusApply = "apply"
    fileprivate let StatusAgreeApply = "agreeApply"
    fileprivate let StatusDisagreeApply = "disagreeApply"
    fileprivate var status:String?
    fileprivate var otherEmail:String?
    fileprivate var tableView:UITableView!
    fileprivate var applyGroup:[XBRelationConcernModel] = []
    fileprivate var myConcern:[XBRelationConcernModel] = []
    fileprivate var concernMe:[XBRelationConcernModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userID = XBUserManager.shared.currentAccount() {
            if let loginUser = XBUserManager.shared.user(uid: userID) {
                self.loginUser = loginUser
            }
        }
        self.view.backgroundColor = UIColor.white
        setupNavigation()
        setupSplitView()
        setupScrollView()
        setupTableView()
        //refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    
    //MARK: - UI Setting
    private func setupNavigation() {
        naviBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: view.width, height:90*UIRate))
        naviBackground.image = UIImage(named: "RectHeader")
        titleLabel = UILabel()
        titleLabel.text = "亲情关注"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFontSize(size: 27)
        titleLabel.sizeToFit()
        titleLabel.centerX = naviBackground.centerX
        titleLabel.top = UIRate * 32
        naviBackground.addSubview(titleLabel)
        view.addSubview(naviBackground)
    }
    
    private func setupSplitView() {
        splitView = XBSplitView(frame: CGRect(x: 0, y: naviBackground.bottom, width: view.width, height: 77))
        splitView.tapSplitButton = { [weak self] (index) in
            if self?.currentIndex != index {
                self?.currentIndex = index
            } else {
                if index == 2 {
                    self?.concernMeVC.loadData()
                }
            }
            var offset = self!.scollView.contentOffset
            offset.x = CGFloat(index) * self!.scollView.width
            self!.scollView.setContentOffset(offset, animated: true)
        }
        view.addSubview(splitView)
    }
    
    private func setupTableView() {
        
        tableView = UITableView(frame: CGRect(x:0, y:splitView.bottom-8, width:view.width, height:view.height-159), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 20
        tableView.delaysContentTouches = false
        tableView.register(XBApplyConcernCell.self, forCellReuseIdentifier: ApplyConcern)
        tableView.register(XBMyConcernCell.self, forCellReuseIdentifier: MyConcern)
        tableView.register(XBConcernMeCell.self, forCellReuseIdentifier: ConcernMe)
        view.addSubview(tableView)
        tableView.isHidden = true
    }
    
    private func setupScrollView() {
        
        scollView = UIScrollView(frame: CGRect(x:0, y:splitView.bottom-8, width:view.width, height:view.height-159))
        scollView.delegate = self
        scollView.backgroundColor = UIColor.white
        view.addSubview(scollView)
        
        setupChildViewControllers()
        
        self.childViews = []
        for i in 0..<self.childViewControllers.count {
            let childView = self.childViewControllers[i].view
            self.childViews.append(childView!)
        }
        
        addChildViews()
        
    }
    
    private func setupChildViewControllers() {
        applyConcernVC = XBApplyConcernViewController()
        myConcernMeVC = XBMyConcernViewController()
        concernMeVC = XBConcernMeViewController()
        
        self.addChildViewController(applyConcernVC)
        self.addChildViewController(myConcernMeVC)
        self.addChildViewController(concernMeVC)
    }
    
    fileprivate func addChildViews() {
        let index = Int(scollView.contentOffset.x) / Int(scollView.width)
        let childView = childViews[index]
        if childView.window == nil {
            childView.frame = scollView.bounds
            scollView.addSubview(childView)
        }
    }
    
    //MARK: - Action
    @objc private func back() {
        navigationController!.popViewController(animated: true)
    }
    
    @objc private func refresh() {
        getConcern { [weak self](success) in
            if success {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Operations
    
    private func getConcern(complete:@escaping ((Bool)->())) {
        let params:Dictionary = ["Email":loginUser.Email!]
        let url = baseRequestUrl + "concern/getConcern"
        
        XBNetworking.share.postWithPath(path: url, paras: params, success: { [weak self] (result) in
            let json = result as! JSON
            var result = false
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code] == 1 {
                self?.clear()
                self?.view.makeToast(message)
                self?.makeTableData(json)
                result = true
            } else {
                SVProgressHUD.showError(withStatus: message)
                result = false
            }
            complete(result)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    fileprivate func agree(otherEmail:String) {
        let other = XBUserManager.shared.user(uid: otherEmail)!
        let params:Dictionary = ["myEmail":loginUser.Email!,
                                 "otherEmail":otherEmail,
                                 "firstName":loginUser.firstName!,
                                 "middleName":loginUser.middleName ?? "",
                                 "lastName":loginUser.lastName!,
                                 "otherName":other.Name ?? ""]
        let url = baseRequestUrl + "concern/agree"
        XBNetworking.share.postWithPath(path: url, paras: params, success: { [weak self](result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code].intValue == applyPass {
                SVProgressHUD.showSuccess(withStatus: message)
                self?.refresh()
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    fileprivate func disagree(otherEmail:String) {
        let params:Dictionary = ["myEmail":loginUser.Email!,
                                 "otherEmail":otherEmail]
        let url = baseRequestUrl + "concern/disagree"
        XBNetworking.share.postWithPath(path: url, paras: params, success: { [weak self](result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code].intValue == applyPass {
                SVProgressHUD.showSuccess(withStatus: message)
                self?.refresh()
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    fileprivate func cancelConcern(otherEmail:String, flag:String) {
        let params:Dictionary = ["myEmail":loginUser.Email!,
                                   "otherEmail":otherEmail,
                                   "flog":flag ]
        let url = baseRequestUrl + "concern/cancel"
        XBNetworking.share.postWithPath(path: url, paras: params, success: { [weak self](result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code].intValue == cancelNotice {
                SVProgressHUD.showSuccess(withStatus: message)
                self?.refresh()
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    //MARK: - misc
    private func clear() {
        tableGroups.removeAll()
        applyGroup.removeAll()
        myConcern.removeAll()
        concernMe.removeAll()
    }
    
    private func makeTableData(_ json:JSON) {
        let applyConcernJson = json[data]["applyConcern"].arrayValue
        let myConcernJson = json[data]["myConcern"].arrayValue
        let concernMeJson = json[data]["concernMe"].arrayValue
        
        deal(dataArary: &applyGroup, with: applyConcernJson, and: ApplyConcern)
        deal(dataArary: &myConcern, with: myConcernJson, and: MyConcern)
        deal(dataArary: &concernMe, with: concernMeJson, and: ConcernMe)
    }
    
    private func deal(dataArary: inout [XBRelationConcernModel], with jsonArray:[JSON], and tag:String) {
        let groupItem = XBTableGroupItem()
        groupItem.headerTitle = tag
        
        for i in 0..<jsonArray.count {
            let json = jsonArray[i]
            let email = json["Email"].stringValue
            self.checkUserExistInDB(userJson: json)
            let user = XBUserManager.shared.user(uid: email)
            
            let model = XBRelationConcernModel()
            model.tag = tag
            model.user = user
            dataArary.append(model)
        }
        groupItem.items = dataArary
        tableGroups.append(groupItem)
    }
    
    private func checkUserExistInDB(userJson:JSON) {
        XBUserManager.shared.addUser(userJson: userJson)
    }
    
    fileprivate func showDealApplyAlert(user:XBUser, status:String) {
        self.status = status
        otherEmail = user.Email!
        var name = ""
        if let fullName = user.Name {
            name = fullName
        }
        let alert = LGAlertView(title: "\(name)'s apply\nContinue?", message:nil, style: .alert, buttonTitles: ["Agree"], cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, delegate: self)
        alert.showAnimated()
    }
    
}

extension XBRelationNoticeController: UITableViewDataSource {
    //MARK: - UITableViewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = tableGroups[section]
        return group.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:XBRelationConcernModel!
        let group = tableGroups[indexPath.section]
        model = group.items[indexPath.row] as? XBRelationConcernModel
        
        var cell:XBRelationConcernCell! = XBRelationConcernCell()
        switch model.tag {
        case ApplyConcern:
            let applyCell = tableView.dequeueReusableCell(withIdentifier: ApplyConcern) as! XBApplyConcernCell
            applyCell.clickAgreeButton = {[weak self] user in
                self?.showDealApplyAlert(user: user, status: self!.StatusAgreeApply)
            }
            applyCell.clickRefuseButton = {[weak self] user in
                self?.showDealApplyAlert(user: user, status: self!.StatusDisagreeApply)
            }
            cell = applyCell
        case MyConcern:
            let myConcernCell = tableView.dequeueReusableCell(withIdentifier: MyConcern) as! XBMyConcernCell
            myConcernCell.clickCancelButton = {[weak self] user in
                self?.cancelConcern(otherEmail: user.Email!, flag: "true")
            }
            cell = myConcernCell
        case ConcernMe:
            let concernMeCell = tableView.dequeueReusableCell(withIdentifier: ConcernMe) as! XBConcernMeCell
            concernMeCell.clickCancelButton = {[weak self] user in
                self?.cancelConcern(otherEmail: user.Email!, flag: "false")
            }
            cell = concernMeCell
        default:break
        }
        cell.model = model
        
        return cell
    }
}

extension XBRelationNoticeController: UITableViewDelegate, LGAlertViewDelegate {
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableGroups[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return tableGroups[section].footerTitle
    }
    
    //UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.addChildViews()
    }
    
    //MARK: - LGAlertViewDelegate
    func alertView(_ alertView: LGAlertView, buttonPressedWithTitle title: String?, index: UInt) {
        if index == 0 {
            if status == StatusApply {
            } else if status == StatusAgreeApply {
                self.agree(otherEmail: otherEmail!)
            } else if status == StatusDisagreeApply {
                self.disagree(otherEmail: otherEmail!)
            }
        }
    }
}
