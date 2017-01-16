//
//  MainItemModel.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/14.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class MainItemModel: NSObject {
    
    init(image:String, title:String, enabled:Bool) {
        self.image = image
        self.title = title
        self.enabled = enabled
    }

    public var image:String?
    public var title:String?
    public var enabled:Bool

}
