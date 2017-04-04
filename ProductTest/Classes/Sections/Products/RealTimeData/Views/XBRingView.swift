//
//  XBRingView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/12.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBRingView: UIView {
    
    var strokeWidth:CGFloat = 0
    var strokeColor:UIColor?
    
    var maxValue:CGFloat = 0
    var increment:CGFloat = 0
    
    var progress:CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var ringRect:CGRect {
        let radius = (self.height - self.strokeWidth) * 0.5
        return CGRect(x: strokeWidth*0.5, y: strokeWidth*0.5, width: 2*radius, height: 2*radius)
    }

    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
    
        let backGroundPath = UIBezierPath(ovalIn: self.ringRect)
        ctx?.setLineWidth(self.strokeWidth)
        ctx?.setLineCap(CGLineCap.round)
        UIColorHex("edebea", 1).set()
        ctx?.addPath(backGroundPath.cgPath)
        ctx?.strokePath()

        let startA = -M_PI_2
        let endA   = -M_PI_2 + Double(self.progress) * M_PI * 2
        drawArc(startA: CGFloat(startA), endA: CGFloat(endA), color: self.strokeColor!, in: rect, ctx: ctx)
        
        drawText()
    }
    
    func drawArc(startA:CGFloat, endA:CGFloat, color:UIColor, in rect:CGRect, ctx:CGContext?) {
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = (self.height - self.strokeWidth) * 0.5
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startA), endAngle: CGFloat(endA), clockwise: true)
        ctx?.setLineWidth(self.strokeWidth)
        ctx?.setLineCap(.butt)
        color.set()
        ctx?.addPath(path.cgPath)
        ctx?.strokePath()
    }
    
    func drawText() {
        let score = "\(Int(self.progress * 100))" as NSString
        //获取文字的rect
        let textRect = score.boundingRect(with: CGSize(width:70, height:40), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFontSize(size: 40)], context: nil)
        score.draw(in: CGRect(x:(self.width-textRect.width)/2,y:self.height*0.5-37,width:textRect.width,height:textRect.height), withAttributes: [NSFontAttributeName:UIFontSize(size: 40)])
        let text = "睡眠评分" as NSString
        text.draw(in: CGRect(x:self.width*0.5-30,y:self.height*0.5+15,width:60,height:20), withAttributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
    }

}
