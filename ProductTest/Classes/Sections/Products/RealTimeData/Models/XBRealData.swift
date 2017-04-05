//
//  XBRealData.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/4/4.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON

public enum XBEventType : Int {
    
    case offline = 0
    
    case onBed = 2
    
    case turntoss = 3
    
    case noBody = 4
    
    case motivate = 10
    
    
}

class XBRealData: NSObject {
    
    var breath:Int = 0
    var heart:Int = 0
    var event:Int = 0
    
    
    func add(_ json:JSON) {
        for (key,subJson):(String, JSON) in json {
            let value = subJson.intValue
            self.setValue(value, forKey: key)
        }
    }
    
    class func image(_ type:XBEventType) -> UIImage {
        switch type {
        case .offline: return UIImage.imageWith(UIColor.gray)!
        case .onBed: return #imageLiteral(resourceName: "onBedR")
        case .motivate: return #imageLiteral(resourceName: "motivateR")
        case .noBody: return #imageLiteral(resourceName: "nobodyR")
        case .turntoss: return #imageLiteral(resourceName: "motivateR")
        }
    }

}
