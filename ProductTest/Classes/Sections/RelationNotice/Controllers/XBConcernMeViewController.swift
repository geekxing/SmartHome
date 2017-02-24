//
//  XBConcernMeViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/20.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import SVProgressHUD

class XBConcernMeViewController: UIViewController {
    
    private var loginUser:XBUser? {
        if let userID = XBUserManager.shared.currentAccount() {
            if let loginUser = XBUserManager.shared.user(uid: userID) {
                return loginUser
            }
        }
        return nil
    }
    
    fileprivate var tableView:UITableView!
    
    fileprivate var tableGroups:[XBTableGroupItem] = []
    fileprivate var applyGroup:[XBRelationConcernModel] = []
    fileprivate var concernMe:[XBRelationConcernModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    //MARK: - Setup
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.contentInset = UIEdgeInsetsMake(32, 0, 0, 0)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 20
        tableView.delaysContentTouches = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71.0
        tableView.register(XBApplyConcernCell.self, forCellReuseIdentifier: ApplyConcern)
        tableView.register(XBConcernMeCell.self, forCellReuseIdentifier: ConcernMe)
        view.addSubview(tableView)
    }

    //MARK: - Operations
    
    func loadData() {
        getConcern { [weak self](success) in
            if success {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func getConcern(complete:@escaping ((Bool)->())) {
        let params:Dictionary = ["Email":loginUser!.Email!]
        let url = baseRequestUrl + "concern/getConcern"
        
        XBNetworking.share.postWithPath(path: url, paras: params, success: { [weak self] (result) in
            let json = result as! JSON
            var result = false
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code] == 1 {
                self?.clear()
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
    
    
    private func makeTableData(_ json:JSON) {
        let applyConcernJson = json[data]["applyConcern"].arrayValue
        let concernMeJson = json[data]["concernMe"].arrayValue
        
        deal(dataArary: &applyGroup, with: applyConcernJson, and: ApplyConcern)
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
    
    //MARK: - Private
    private func clear() {
        tableGroups.removeAll()
        applyGroup.removeAll()
        concernMe.removeAll()
    }
    
    private func checkUserExistInDB(userJson:JSON) {
        XBUserManager.shared.addUser(userJson: userJson)
    }
    
}

extension XBConcernMeViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Datasource
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
            
            }
            applyCell.clickRefuseButton = {[weak self] user in
    
            }
            cell = applyCell
            
        case ConcernMe:
            let concernMeCell = tableView.dequeueReusableCell(withIdentifier: ConcernMe) as! XBConcernMeCell
            concernMeCell.clickCancelButton = {[weak self] user in
            }
            cell = concernMeCell
        default:break
        }
        cell.model = model

        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = tableGroups[section]
        if group.items.count == 0 {return nil}
        return tableGroups[section].headerTitle
    }
    
    
}
