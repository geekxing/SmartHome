//
//  GlobalDefines.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/4.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import Foundation

let SCALE = UIScreen.main.scale
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let STATUS_BAR_HEIGHT = UIApplication.shared.statusBarFrame.height
let UIRate = SCREEN_WIDTH / 375
let UIRateH = SCREEN_HEIGHT / 667

let XB_DARK_TEXT = UIColorHex("333333", 1)

///产品类型枚举
public enum XBProductType:Int {
    case bed
    case pillow
    case ring
}

func errorMsg(_ url:String, code:Int) -> String {
    
    var errorMsg = ""
    if url == LOGIN {
        switch code {
        case 1001:
            errorMsg = NSLocalizedString("Email does not exist", comment: "")
        case 1000:
            errorMsg = NSLocalizedString("Invalid Email or Password", comment: "")
        default:break
        }
    } else if url == REGIST {
        switch code {
        case 1002:
            errorMsg = NSLocalizedString("Email already exists", comment: "")
        case 0, 1005:
            errorMsg = NSLocalizedString("Server Error", comment: "")
        default:break
        }
    } else if url == MODIFY {
        switch code {
        case 3005:
            errorMsg = NSLocalizedString("Server Error", comment: "")
        default:break
        }
    } else if url == FORGET {
        if code == 1001 {
            errorMsg = NSLocalizedString("Email does not exist", comment: "")
        }
    } else if url == VERIFY_CODE {
        switch code {
        case 1006:
            errorMsg = NSLocalizedString("Verification failed", comment: "")
        case 1007:
            errorMsg = NSLocalizedString("Too many verification errors", comment: "")
        case 1008:
            errorMsg = NSLocalizedString("Verification expired", comment: "")
        default:break
        }
    } else if url == MODIFY_PWD {
        if code == 3005 {
            errorMsg = NSLocalizedString("Server Error", comment: "")
        }
    } else if url == CHECK_TOKEN {
        if code == 1006 {
            errorMsg = NSLocalizedString("invalid token", comment: "")
        }
    } else if url == QUERY {
        switch code {
        case 2:
            errorMsg = NSLocalizedString("search failed", comment: "")
        case 1001:
            errorMsg = NSLocalizedString("User does not exist", comment: "")
        default:break
        }
    } else if url == APPLY {
        switch code {
        case 1001:
            errorMsg = NSLocalizedString("User does not exist", comment: "")
        case 1002:
            errorMsg = NSLocalizedString("Already applied", comment: "")
        case 1003:
            errorMsg = NSLocalizedString("You can't concern yourself", comment: "")
        default:break
        }
    } else if url == HANDLE {
        if code == 0  {
            errorMsg = NSLocalizedString("operation failed", comment: "")
        }
    } else if url == CANCEL {
        if code == 0 {
            errorMsg = NSLocalizedString("operation failed", comment: "")
        }
    } else if url == DEVICE_ADD {
        switch code {
        case 1001:
            errorMsg = NSLocalizedString("SN does not exist", comment: "")
        case 1009:
            errorMsg = NSLocalizedString("you can't bind the same type device", comment: "")
        case 0:
            errorMsg = NSLocalizedString("bind failed", comment: "")
        default:break
        }
    } else if url == DEVICE_DELETE {
        if code == 0 {
            errorMsg = NSLocalizedString("unbind failed", comment: "")
        }
    }
    return errorMsg
    
}

func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func SMRandomColor() -> UIColor {
    return RGBA(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)), a: 1)
}

func UIColorHex(_ hex:String, _ alpha:CGFloat) -> UIColor {
    var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = cString.substring(from: index)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.red
    }
    
    let rIndex = cString.index(cString.startIndex, offsetBy: 2)
    let rString = cString.substring(to: rIndex)
    let otherString = cString.substring(from: rIndex)
    let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
    let gString = otherString.substring(to: gIndex)
    let bIndex = cString.index(cString.endIndex, offsetBy: -2)
    let bString = cString.substring(from: bIndex)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

func UIFontSize(_ size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

//MARK: - Notifications

let XBSearchSleepCareHistoryNotification = "kSearchSleepCareHistoryNotification"
let XBDrawFrequecyDidChanged = "kDrawFrequecyDidChanged"
let XBDateSelectViewDidSelectDate = "kDateSelectViewDidSelectDate"

