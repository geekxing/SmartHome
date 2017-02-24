//
//  XBProductVersionController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/16.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBProductVersionController: UIViewController {
    
    var tableGroups:[XBTableGroupItem] = []
    private var loginUser:XBUser!
    fileprivate var tableView:UITableView!

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
        makeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    //MARK: - UI Setting
    private func setupNavigation() {
        UIApplication.shared.statusBarStyle = .default
        title = "产品升级"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 20
        tableView.delaysContentTouches = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    //MARK: - Data
    private func makeData() {
        let groupItem1 = XBTableGroupItem()
        groupItem1.headerTitle = "公司新闻"
        var newsArray = [String]()
        for i in 0..<10 {
            newsArray.append("新闻\(i)")
        }
        groupItem1.items = newsArray as [AnyObject]
        tableGroups.append(groupItem1)
        let groupItem2 = XBTableGroupItem()
        groupItem2.headerTitle = "新品发布"
        tableGroups.append(groupItem2)
        let groupItem3 = XBTableGroupItem()
        groupItem3.headerTitle = "产品升级"
        tableGroups.append(groupItem3)
    }
    
}

extension XBProductVersionController: UITableViewDataSource {
    //MARK: - UITableViewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = tableGroups[section]
        return group.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let group = tableGroups[indexPath.section]
        let text = group.items[indexPath.row] as! String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = text
        
        return cell
    }
    
}

extension XBProductVersionController: UITableViewDelegate {
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
}
