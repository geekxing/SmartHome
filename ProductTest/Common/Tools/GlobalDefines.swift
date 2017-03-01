//
//  GlobalDefines.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/4.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import Foundation

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let STATUS_BAR_HEIGHT = UIApplication.shared.statusBarFrame.height
let UIRate = SCREEN_WIDTH / 375

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

func UIFontSize(size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

//MARK: - Notifications

let XBSearchSleepCareHistoryNotification = "kXBSearchSleepCareHistoryNotification"
