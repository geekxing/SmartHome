//
//  XBRealDataViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/26.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

let XBDrawFrequecyDidChanged = "kXBDrawFrequecyDidChanged"

class XBRealDataViewController: XBBaseViewController {
    
    static let dataCellId = "dataCellId"
    static let detailCellId = "detailCellId"
    
    var heartRateValue = 0
    var breathRateValue = 0
    private var timer:Timer?
    
    override var naviBackgroundImage: UIImage? {
        return UIImage(named: "RectHeader")
    }
    
    override var naviTitle: String? {
        return "实时数据"
    }

    fileprivate var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupTableView()
        makeData()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    //MARK: - UI Setting
    
    private func setupTableView() {
        let naviHeight = (naviBackgroundImage!.size.height)
        tableView = UITableView(frame: CGRect(x: 0, y: naviHeight, width: view.width, height: view.height-naviHeight))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.delaysContentTouches = false
        tableView.register(XBRealDataTableCell.self, forCellReuseIdentifier: XBRealDataViewController.dataCellId)
        tableView.register(XBRealDetailTableCell.self, forCellReuseIdentifier: XBRealDataViewController.detailCellId)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    private func makeData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateData), userInfo: nil, repeats: true)
            self.updateData()
        })
    }
    
    @objc private func updateData() {
        self.heartRateValue = Int(arc4random_uniform(51))+50
        self.breathRateValue =  Int(arc4random_uniform(30))
        NotificationCenter.default.post(name: Notification.Name(rawValue: XBDrawFrequecyDidChanged), object: nil, userInfo:["obj":Double(heartRateValue)])
        self.tableView.reloadData()
    }
    
    //MARK: - misc
    
    fileprivate func makeScoreAttributeString(score:String, text:String) -> NSAttributedString {
        let scoreAttri = NSMutableAttributedString(string: score, attributes: [NSFontAttributeName:UIFontSize(size: 26),
                                                                               NSForegroundColorAttributeName:UIColor.black])
        let textAttri = NSMutableAttributedString(string: "\n\(text)", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12),
                                                                                    NSForegroundColorAttributeName:XB_DARK_TEXT])
        scoreAttri.append(textAttri)
        return scoreAttri
    }

}

extension XBRealDataViewController: UITableViewDataSource {
    
    //MARK: - UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = indexPath.row != 2 ?
        XBRealDataViewController.dataCellId : XBRealDataViewController.detailCellId
        
        let cell = tableView.dequeueReusableCell(withIdentifier:identifier) as! XBRealDataTableCell
        if indexPath.row == 0 {
            cell.imageView?.image = #imageLiteral(resourceName: "heart")
            cell.textLabel?.text = "心率"
            cell.valueLabel.attributedText = self.makeScoreAttributeString(score: "\(self.heartRateValue)", text: "次/分")
            cell.shouldEnableEcgDisplay = true
        } else if indexPath.row == 1 {
            cell.imageView?.image = #imageLiteral(resourceName: "breath-1")
            cell.textLabel?.text = "呼吸率"
            cell.valueLabel.attributedText = self.makeScoreAttributeString(score: "\(self.breathRateValue)", text: "次/分")
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "sleep")
            cell.textLabel?.text = "状态"
        }
        
        return cell
    }
    
}

extension XBRealDataViewController: UITableViewDelegate {
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 138
        case 1: return 138
        default: return 305
        }
    }
}
