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

class XBRelationNoticeController: UIViewController {
    
    var tableGroups:[XBTableGroupItem] = []
    private var loginUser:XBUser!
    
    fileprivate let StatusApply = "apply"
    fileprivate let StatusDealApply = "dealApply"
    fileprivate var status:String?
    fileprivate var otherEmail:String?
    fileprivate var tableView:UITableView!
    fileprivate var applyGroup:[XBRelationConcernModel] = []
    fileprivate var myConcern:[XBRelationConcernModel] = []
    fileprivate var concernMe:[XBRelationConcernModel] = []
    fileprivate var searchResult:[XBRelationConcernModel] = []
    fileprivate var searchController:UISearchController?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userID = XBUserManager.shared.currentAccount() {
            if let loginUser = XBUserManager.shared.user(uid: userID) {
                self.loginUser = loginUser
            }
        }
        self.view.backgroundColor = UIColor.white
        setupNavigation()
        setupTableView()
        setupSearchComponent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - UI Setting
    private func setupNavigation() {
        UIApplication.shared.statusBarStyle = .default
        title = "亲情关注"
        let backButton = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(back))
        let refreshButton = UIBarButtonItem.init(title: "Refresh", style: .plain, target: self, action: #selector(refresh))
        navigationItem.leftBarButtonItems = [backButton, refreshButton]
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 20
        tableView.delaysContentTouches = false
        tableView.register(XBApplyConcernCell.self, forCellReuseIdentifier: ApplyConcern)
        view.addSubview(tableView)
    }
    
    private func setupSearchComponent() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.view.backgroundColor = UIColor.clear
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        searchController?.searchBar.placeholder = "search user by email"
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = searchController?.searchBar
    }
    
    //MARK: - Action
    @objc private func back() {
        navigationController?.popViewController(animated: true)
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
                SVProgressHUD.showSuccess(withStatus: message)
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
    
    fileprivate func search(email:String, complete:@escaping ((_ email:String, _ name:String)->())){
        let params:Dictionary = ["Email":email]
        let url = baseRequestUrl + "concern/query"
        XBNetworking.share.postWithPath(path: url, paras: params, success: {[weak self] (result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code] == 1 {
                SVProgressHUD.showSuccess(withStatus: message)
                debugPrint(json[data])
                let email = json["Email"].stringValue
                let name = json[data].stringValue
                self?.checkUserExistInDB(email: email, name: name)
                complete(email, name)
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    fileprivate func apply(email:String) {
        let params:Dictionary = ["myEmail":loginUser.Email!,
                                "otherEmail":email,
                                "firstName":loginUser.firstName!,
                                "middleName":loginUser.middleName ?? "",
                                "lastName":loginUser.lastName!]
        let url = baseRequestUrl + "concern/apply"
        XBNetworking.share.postWithPath(path: url, paras: params, success: { (result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code].intValue == applyNotice {
                SVProgressHUD.showSuccess(withStatus: message)
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
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
                                 "otherName":other.fullName ?? ""]
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
        for i in 0..<jsonArray.count {
            let json = jsonArray[i]
            let model = XBRelationConcernModel()
            let user = XBUser()
            user.Email = json["Email"].stringValue
            user.fullName = json["Name"].stringValue
            model.user = user
            model.tag = tag
            dataArary.append(model)
            self.checkUserExistInDB(email: user.Email!, name: user.fullName!)
            let groupItem = XBTableGroupItem()
            groupItem.headerTitle = tag
            groupItem.items = dataArary
            tableGroups.append(groupItem)
        }
    }
    
    private func checkUserExistInDB(email: String, name:String) {
        guard (XBUserManager.shared.user(uid: email) != nil) else {
            let user = XBUser()
            user.Email = email
            user.fullName = name
            XBUserManager.shared.add(user: user)
            return
        }
    }
    
    fileprivate func showDealApplyAlert(user:XBUser) {
        status = StatusDealApply
        otherEmail = user.Email!
        var name = ""
        if let fullName = user.fullName {
            name = fullName
        }
        let alert = LGAlertView(title: "\(name)'s apply\nContinue?", message:nil, style: .alert, buttonTitles: ["Agree"], cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, delegate: self)
        alert.showAnimated()
    }
    
}

extension XBRelationNoticeController: UITableViewDataSource {
    //MARK: - UITableViewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController!.isActive {
            return 1
        } else {
            return tableGroups.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController!.isActive {
            return searchResult.count
        }
        let group = tableGroups[section]
        return group.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:XBRelationConcernModel!
        if searchController!.isActive {
            model = searchResult[indexPath.row] as XBRelationConcernModel
        } else {
            let group = tableGroups[indexPath.section]
            model = group.items[indexPath.row] as? XBRelationConcernModel
        }
        
        var cell:XBRelationConcernCell! = XBRelationConcernCell()
        switch model.tag {
        case ApplyConcern:
            let applyCell = XBApplyConcernCell(style: .default, reuseIdentifier: ApplyConcern)
            applyCell.clickAgreeButton = {[weak self] user in
                self?.showDealApplyAlert(user: user)
            }
            applyCell.clickRefuseButton = {[weak self] user in
                self?.showDealApplyAlert(user: user)
            }
            cell = applyCell
        case MyConcern:break
        case ConcernMe:break
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
        if searchController!.isActive {
            return ""
        }
        return tableGroups[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if searchController!.isActive {
            return ""
        }
        return tableGroups[section].footerTitle
    }
    
    //MARK: - LGAlertViewDelegate
    func alertView(_ alertView: LGAlertView, buttonPressedWithTitle title: String?, index: UInt) {
        if index == 0 {
            if status == StatusApply {
                self.apply(email: otherEmail ?? "")
            } else if status == StatusDealApply {
                self.agree(otherEmail: otherEmail!)
            }
        }
    }
}

extension XBRelationNoticeController: UISearchResultsUpdating, UISearchBarDelegate {
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let allList = applyGroup + myConcern + concernMe
        let searchText = searchController.searchBar.text!
        searchResult.removeAll()
        searchResult = allList.filter { $0.user.Email.contains(searchText) }
        self.tableView.reloadData()
    }
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(email: searchBar.text ?? "") { [weak self](email, name) in
            if let user = XBUserManager.shared.user(uid: email) {
                self?.otherEmail = email
                self?.status = self?.StatusApply
                let model = XBRelationConcernModel()
                model.user = user
                model.tag = "1"
                self?.searchResult.append(model)
                self?.tableView.reloadData()
                let alert = LGAlertView(title: "Find!\nEmail:\(email)\nName:\(name)", message: "Continue to apply?", style: .alert, buttonTitles: ["Confirm"], cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, delegate: self)
                alert.showAnimated()
            }
        }
    }
}
