//
//  XBRealDataViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/26.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

let XBDrawFrequecyDidChanged = "kXBDrawFrequecyDidChanged"

class XBRealDataViewController: XBBaseViewController {
    
    static var netError:Int = 0
    static let dataCellId = "dataCellId"
    static let detailCellId = "detailCellId"
    
    var realData:XBRealData? {
        didSet {
            
        }
    }
    
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
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(makeData), userInfo: nil, repeats: true)
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
    
    @objc private func makeData() {
        
        let params:Dictionary = ["sn":"b0b448f9fa58"]
        
        XBNetworking.share.postWithPath(path: REALDATA, paras: params,
                                        success: {[weak self]result in
                                            XBRealDataViewController.netError = 0
                                            let json:JSON = result as! JSON
                                            debugPrint(json)
                                            let message = json[Message].stringValue
                                            if json[Code].intValue == 1 {
                                                let real = XBRealData()
                                                real.add(json[XBData])
                                                self?.realData = real
                                                self?.updateComplete()
                                            } else {
                                                XBRealDataViewController.netError += 1
                                                if XBRealDataViewController.netError == 3 {
                                                    SVProgressHUD.showError(withStatus: message)
                                                }
                                            }
            }, failure: { (error) in
                XBRealDataViewController.netError += 1
                if XBRealDataViewController.netError == 3 {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
        })
    
    }
    
    func updateComplete() {
        
        if self.realData != nil {
            NotificationCenter.default.post(name: Notification.Name(rawValue: XBDrawFrequecyDidChanged), object: nil, userInfo:["obj":Double(realData!.heart)])
            self.tableView.reloadData()
        }
        
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
            cell.shouldEnableEcgDisplay = true
        } else if indexPath.row == 1 {
            cell.imageView?.image = #imageLiteral(resourceName: "breath-1")
            cell.textLabel?.text = "呼吸率"
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "sleep")
            cell.textLabel?.text = "状态"
        }
        if self.realData != nil {
            if indexPath.row == 0 {
                cell.valueLabel.attributedText = self.makeScoreAttributeString(score: "\(realData!.heart)", text: "次/分")
            } else if indexPath.row == 1 {
                cell.valueLabel.attributedText = self.makeScoreAttributeString(score: "\(realData!.breath)", text: "次/分")
            } else {
                cell.event = realData!.event
            }
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
