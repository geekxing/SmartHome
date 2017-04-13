//
//  XBProductVersionController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/16.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBProductVersionController: XBBaseViewController {
    
    static let productCellId = "productCellId"
    static let reuseHeaderId = "reuseHeaderId"
    
    override var naviTitle: String? {
        return "增值服务"
    }
    
    override var naviBackgroundImage: UIImage? {
        return UIImage(named: "RectHeader")
    }
    
    var tableGroups:[XBTableGroupItem] = []
    fileprivate var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupTableView()
        makeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    //MARK: - UI Setting

    private func setupTableView() {
        let naviHeight = (naviBackgroundImage!.size.height)
        tableView = UITableView(frame: CGRect(x: 0, y: naviHeight, width: view.width, height: view.height-naviHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 20
        tableView.delaysContentTouches = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(XBMyPurchaseTableCell.self, forCellReuseIdentifier: XBProductVersionController.productCellId)
        tableView.register(XBProductVersionSectionHeader.self, forHeaderFooterViewReuseIdentifier: XBProductVersionController.reuseHeaderId)
        view.addSubview(tableView)
    }
    
    //MARK: - Data
    private func makeData() {
        let groupItem1 = XBTableGroupItem()
        groupItem1.headerTitle = "公司新闻"
        var newsArray = [String]()
        for i in 0..<5 {
            newsArray.append("新闻\(i)")
        }
        groupItem1.items = newsArray as [AnyObject]
        tableGroups.append(groupItem1)
        
        let groupItem2 = XBTableGroupItem()
        groupItem2.headerTitle = "新品发布"
        groupItem2.items = newsArray as [AnyObject]
        tableGroups.append(groupItem2)
        
        let groupItem3 = XBTableGroupItem()
        let item = XBProductModel(productName:"智能床垫", typesn: loginUser!.type1sn, typeIp: loginUser!.type1Ip, level: loginUser!.level1, deadline: loginUser!.deadline1)
        let item2 = XBProductModel(productName:"智能枕", typesn: loginUser!.type1sn, typeIp: loginUser!.type1Ip, level: loginUser!.level1, deadline: loginUser!.deadline1)
        let item3 = XBProductModel(productName:"智能手环", typesn: loginUser!.type1sn, typeIp: loginUser!.type1Ip, level: loginUser!.level1, deadline: loginUser!.deadline1)
        groupItem3.items = [item, item2, item3]
        
        groupItem3.headerTitle = "产品升级\n\n您当前拥有的产品:"
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if indexPath.section == 2 {
            let model = group.items[indexPath.row] as! XBProductModel
            let cell3 = tableView.dequeueReusableCell(withIdentifier: XBProductVersionController.productCellId) as! XBMyPurchaseTableCell
            cell3.model = model
            return cell3
        }
        
        return cell
    }
    
}

extension XBProductVersionController: UITableViewDelegate {
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 44
        case 1: return 44
        default: return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 93
        }
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: XBProductVersionController.reuseHeaderId) as! XBProductVersionSectionHeader
        headerSectionView.titleLabel.text = tableGroups[section].headerTitle
        return headerSectionView
    }
}
