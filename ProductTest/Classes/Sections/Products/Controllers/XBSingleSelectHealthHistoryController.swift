//
//  XBSingleSelectHealthHistoryController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/25.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBSingleSelectHealthHistoryController: UIViewController {
    
    fileprivate let reuseIdentifier = "sleepCellID"
    
    fileprivate let cellSelectedColor = RGBA(r: 220, g: 221, b: 222, a: 1.0)
    
    var headerView:XBHealthCareHeaderView!
    
    var tableView:UITableView!
    var group:[XBSleepData] = []
    
    lazy var dateFormatter:DateFormatter? = {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy/MM/dd"
        return dateFmt
    }()
    
    lazy var image:UIImage? = {
        return UIImage(named: "RectHeader")
    }()
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        listenNotification()
        setupHeader()
        setupTableView()
        view.addSubview(headerView)
        makeData()
    }
    
    func setupHeader() {
        headerView = XBHealthCareHeaderView(.single)
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 121)
    }
    
    private func setupTableView() {
        //高度等于view高-分页器高-选择器高-查询器高
        tableView = UITableView(frame: CGRect(x: 0, y: headerView.bottom, width: view.width, height: view.height-94*UIRate-XBHealthCareViewController.splitViewH-headerView.height-image!.size.height*UIRate))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.tableFooterView = UIView()
        tableView.register(XBSleepHistoryTableCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
    }
    
    private func listenNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(listenSearchData(_:)), name: Notification.Name(rawValue:XBSearchSleepCareHistoryNotification), object: nil)
    }
    
    //MARK: - Notification
    @objc private func listenSearchData(_ aNote:Notification) {
        if !view.isShowingOnKeywindow() {
            return
        }
        let beginDate = dateFormatter?.string(from: headerView.beginDate)
        let endDate   = dateFormatter?.string(from: headerView.endDate)
        print("\(beginDate), \(endDate)")
        makeData()
        self.tableView.reloadData()
    }

    //MARK: - Fake Data
    private func makeData() {
        self.group.removeAll()
        for i in -10 ... 0 {
            let cmps = XBOperateUtils.shared.components(for: headerView.endDate.addingTimeInterval(Double(i*24*3600)))
            let sleepData = XBSleepData(date: "\(cmps.year)/\(cmps.month)/\(cmps.day)", time: "8", score: "90")
            self.group.append(sleepData)
            
        }
    }

}


extension XBSingleSelectHealthHistoryController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.group[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as!XBSleepHistoryTableCell
        cell.model = model
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = group[indexPath.row]
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = model.selected == false ? RGBA(r: 236, g: 236, b: 235, a: 1.0) : cellSelectedColor
        default:
            cell.backgroundColor =  model.selected == false ? UIColor.white : cellSelectedColor
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let date = dateFormatter?.date(from: self.group[indexPath.row].date)
        headerView.setDate(date!, for: &headerView.endDate)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
}

