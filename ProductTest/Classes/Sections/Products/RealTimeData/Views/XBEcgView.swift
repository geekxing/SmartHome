//
//  XBEcgView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/13.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBEcgView: UIView {
    
    var frequency:Double = 0.25 {
        didSet {
            timer?.cancel()
            timer?.scheduleRepeating(deadline: .now(), interval: .milliseconds(Int(1000*frequency)))
            timer?.resume()
        }
    }
    private var pointYs = [CGFloat]()
    private let popYArray:[CGFloat] =
        [0,0,0,0,0,2,-10,0,-2,5,-8,0,0,0,0,2,-10,0,-2,5,-8,0,0,0,0,]
    private var xScale = CGFloat(6.0)
    private var index = 0
    
    private var timer:DispatchSourceTimer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         setup()
    }
    
    deinit {
    }
    
    override func draw(_ rect: CGRect) {
        if pointYs.count == 0 {
            return
        }
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.clear(self.bounds)
        //ctx?.translateBy(x: 0, y: self.height * 0.5)
        ctx?.setLineWidth(2)
        ctx?.setLineJoin(.round)
        ctx?.setStrokeColor(XB_DARK_TEXT.cgColor)
        let path = CGMutablePath()
        
        // __CGAffineTransformMake(a,b,c,d,tx,ty)
        // x = ax + cy + tx   y = bx + dy + ty
        let transform = __CGAffineTransformMake(1, 0, 0, 3, 0, self.height * 0.5)
        //curX -= xScale
        let startY = pointYs.first!
        path.move(to: CGPoint(x:0, y:startY), transform: transform)
        
        for i in 1..<pointYs.count {
            path.addLine(to: CGPoint(x: CGFloat(i)*xScale, y: pointYs[i]), transform: transform)
        }
        ctx?.addPath(path)
        ctx?.strokePath()
        
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.setEventHandler( handler: {
            self.updateData()
        })
        timer?.scheduleRepeating(deadline: .now(), interval: .milliseconds(Int(1000*frequency)))
        timer?.resume()
        NotificationCenter.default.addObserver(self, selector: #selector(changeDrawingMode(_:)), name: Notification.Name.init(rawValue: XBDrawFrequecyDidChanged), object: nil)
    }
    
    @objc private func changeDrawingMode(_ aNote:Notification) {
        self.frequency = Double(3 / (aNote.userInfo!["obj"] as! Double))
    }
    
    @objc private func updateData() {
        pointYs.append(popYArray[index])
        index += 1
        if index == popYArray.count {
            index = 0
        }
        if pointYs.count > popYArray.count {
            pointYs.removeFirst()
        }
        setNeedsDisplay()
    }

}
