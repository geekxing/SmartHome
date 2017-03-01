//
//  XBSleepData.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/26.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBSleepData: NSObject {

    var date:String!
    var time:String!
    var score:String!
    
    var selected = false
    
    convenience init(date:String, time:String, score:String) {
        self.init()
        self.date = date
        self.time = time
        self.score = score
    }
}
