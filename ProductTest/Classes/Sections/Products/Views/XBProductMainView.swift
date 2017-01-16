//
//  XBProductMainView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/15.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBProductMainView: XBMainView {
    
    override var mainItems:[MainItemModel] {
        let btnTitles = ["实时数据", "健康档案", "添加设备", "删除设备"]
        let itemEnables = [false, false, true, false]
        var array = [MainItemModel]()
        for i in 0..<4 {
            let mainitem = MainItemModel(image: "", title:btnTitles[i], enabled:itemEnables[i])
            array.append(mainitem)
        }
        return array
    }
    
    override var currentUser:XBUser {
        didSet {
            self.toggleFunctionEnabled(sn: currentUser.type1sn)
        }
    }
    
    func toggleFunctionEnabled(sn:String?) {
        if sn != nil {
            for btn in squareBtns {
                btn.isEnabled = true
            }
        } else {
            for i in 0..<squareBtns.count {
                let btn = squareBtns[i]
                if i == 2 {
                    btn.isEnabled = true
                } else {
                    btn.isEnabled = false
                }
            }
        }
    }

}
