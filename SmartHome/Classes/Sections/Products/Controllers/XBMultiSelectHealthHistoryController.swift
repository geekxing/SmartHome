//
//  XBMultiSelectHealthHistoryController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/25.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD

class XBMultiSelectHealthHistoryController: XBSingleSelectHealthHistoryController {
    
    override var url:String {
        return type == .me ? DEVICE_DATA : DEVICE_OTHERDATA
    }
    
    override var params:[String:String] {
        
        let startTime = headerView.beginDate.string(format: .custom("MM/dd/yyyy"))
        let endTime =  headerView.endDate.string(format: .custom("MM/dd/yyyy"))
        
        var params:Dictionary = ["token":token,
                                 "startTime":startTime,
                                 "endTime":endTime]
        if type == .other {
            params["email"] = other!.email
        }
        return params
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupHeader() {
        headerView = XBHealthCareHeaderView(.multiple)
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 198)
    }
    
    override func beginSearch() {
        
        if self.group.count == 0 {
            self.view.makeToast("There is no data")
            return
        }
        let selectModels = (group as NSArray).objects(at: selItemIdxSet) as! [XBSleepData]
        if selectModels.count <= 1 {
            UIAlertView(title: "请选择至少两个条目", message: nil, delegate: nil, cancelButtonTitle: "DONE").show()
        } else {
            let mutiVC = XBMultiReportViewController()
            mutiVC.modelArray = selectModels
            self.navigationController?.pushViewController(mutiVC, animated: true)
        }
        
    }
    
    //MARK: - Private
    fileprivate func makeCellChosen() {

        //1.清理所有条目的选中状态
        for item in group {
            item.selected = false
        }
        //2.判断当前点选条目的选中状态
        if selItemIdxSet.count == 0 {
            selItemIdxSet.insert(nowTapIndex)
        } else if selItemIdxSet.contains(nowTapIndex) {
            selItemIdxSet.remove(nowTapIndex)
        } else {
            if nowTapIndex < selItemIdxSet.first! {
                selItemIdxSet.insert(integersIn: nowTapIndex ..< selItemIdxSet.first!)
            } else if nowTapIndex > selItemIdxSet.last! {
                selItemIdxSet.insert(integersIn: selItemIdxSet.last!+1 ... nowTapIndex)
            } else {
                selItemIdxSet.insert(nowTapIndex)
            }
        }
        
        if selItemIdxSet.count != 0 {
            selItemIdxSet.forEach({ (idx) in
                group[idx].selected = true
            })
        }
        
        tableView.reloadData()
    }
    
}

extension XBMultiSelectHealthHistoryController {

    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        nowTapIndex = indexPath.row
        
        makeCellChosen()
        
    }
    
}
