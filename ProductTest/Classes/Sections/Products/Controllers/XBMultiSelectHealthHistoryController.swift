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
    
    fileprivate var minTapIndex     = -1
    fileprivate var nowTapIndex     = -1
    fileprivate var previouTapIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func setupHeader() {
        headerView = XBHealthCareHeaderView(.multiple)
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 198)
    }
    
    //MARK: - Private
    fileprivate func makeCellChosen() {
        
        var chooseNum  = 0;
        for item in group {
            if item.selected == true {
                chooseNum += 1
            }
            item.selected = false
        }
        let beginIndex = minTapIndex
        let endIndex   = chooseNum == 1 && previouTapIndex - nowTapIndex > 0 ? previouTapIndex : nowTapIndex
        
        for i in beginIndex ... endIndex {
            group[i].selected = true
        }
        if previouTapIndex == nowTapIndex && (endIndex - beginIndex == 0) {
            group[nowTapIndex].selected = !group[nowTapIndex].selected
            if group[nowTapIndex].selected == false {
                nowTapIndex = -1
                minTapIndex = -1
                previouTapIndex = -1
            }
        }
        
        tableView.reloadData()
    }
    
}

extension XBMultiSelectHealthHistoryController {

    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        nowTapIndex = indexPath.row
        minTapIndex = min(nowTapIndex, minTapIndex)
        if minTapIndex == -1 {
            minTapIndex = nowTapIndex
        }
        
        let date = dateFormatter?.date(from: self.group[indexPath.row].date)
        
        var configDate = (indexPath.row == minTapIndex) ? headerView.beginDate : headerView.endDate
        headerView.setDate(date!, for: &configDate)
        
        makeCellChosen()
        
        previouTapIndex = nowTapIndex
        
    }
    
}
