//
//  XBApplyConcernViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/20.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class XBApplyConcernViewController: UIViewController {
    
    var loginUser: XBUser? {
        return XBUserManager.shared.loginUser()
    }
    var searchBar:XBRoundedTextField!
    var dataArray = [XBRelationConcernModel]()
    var keyword:String = ""
    
    private var otherEmail:String?
    
    private var scrollView:UIScrollView!
    private var lineView:UIView!
    fileprivate var tableView:UITableView!
    private var searchButton:UIButton!
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupSearchComponent()
        setupTableView()
        scrollView.contentSize = CGSize(width: view.width, height: view.height+10)
    }
    
    
    //MARK: - Setup
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame:view.bounds)
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    private func setupSearchComponent() {
        searchBar = XBRoundedTextField(frame: CGRect(x: 33*UIRate, y: 152*UIRate, width: 265*UIRate, height: 29))
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        scrollView.addSubview(searchBar)
        
        searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(named:"search"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchPeople), for: .touchUpInside)
        searchButton.sizeToFit()
        searchButton.centerY = searchBar.centerY
        searchButton.right = view.width-33*UIRate
        scrollView.addSubview(searchButton)
        
        lineView = UIView(frame: CGRect(x: 33*UIRate, y: searchBar.bottom+27*UIRate, width: view.width-66*UIRate, height: 1))
        lineView.backgroundColor = UIColorHex("595757", 1.0)
        scrollView.addSubview(lineView)
        
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x:0, y:lineView.bottom, width:view.width, height:view.height-159))
        tableView.contentInset = UIEdgeInsetsMake(27, 0, 0, 0)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 20
        tableView.delaysContentTouches = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 54.0
        tableView.register(XBSearchApplyCell.self, forCellReuseIdentifier: SearchApply)
        scrollView.addSubview(tableView)
    }
    
    //MARK: - Operate
    private func search(email:String, complete:@escaping ((_ email:String, _ name:String)->())){
        let params:Dictionary = ["Email":email]
        let url = baseRequestUrl + "concern/query"
        XBNetworking.share.postWithPath(path: url, paras: params, success: {[weak self] (result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code] == 1 {
                debugPrint(json[data])
                let email = json["Email"].stringValue
                let name = json[data].stringValue
                let user = XBUser()
                user.Email = email
                user.Name = name
                XBUserManager.shared.add(user: user)
                complete(email, name)
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func apply(email:String) {
        let params:Dictionary = ["myEmail":loginUser!.Email!,
                                 "otherEmail":email,
                                 "firstName":loginUser!.firstName!,
                                 "middleName":loginUser!.middleName ?? "",
                                 "lastName":loginUser!.lastName!]
        let url = baseRequestUrl + "concern/apply"
        XBNetworking.share.postWithPath(path: url, paras: params, success: {[weak self] (result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code].intValue == applyNotice {
                self?.view.makeToast(message)
            } else if message == "" {
                self?.view.makeToast( "不能重复申请关注")
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    //MARK: - Private
    @objc fileprivate func searchPeople() {
        searchBar.resignFirstResponder()
        search(email: searchBar.text ?? "") { [weak self](email, name) in
            if let user = XBUserManager.shared.user(uid: email) {
                self?.dataArray.removeAll()
                self?.otherEmail = email
                let model = XBRelationConcernModel()
                model.user = user
                model.tag = "1"
                self?.dataArray.append(model)
                self?.tableView.reloadData()
            }
        }
    }

}

extension XBApplyConcernViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        keyword = oldText.replacingCharacters(in: range, with: string)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            searchPeople()
            return true
        } else {
            return false
        }
    }
    
}

extension XBApplyConcernViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchApply) as! XBSearchApplyCell
        cell.model = model
        cell.clickApplyButton = {[weak self] user in
            self?.apply(email: user.Email!)
            self?.dataArray.removeAll()
            tableView.reloadData()
        }
        cell.clickCancelButton = {[weak self] user in
            self?.dataArray.removeAll()
            tableView.reloadData()
        }
        return cell
    }
    
    //MARK: - Delegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
}
