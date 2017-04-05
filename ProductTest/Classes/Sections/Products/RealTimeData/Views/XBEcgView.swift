//
//  XBEcgView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/13.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBEcgView: UIView {
    
    var duration:CFTimeInterval = 0.25 {
        didSet {
            animation4()
        }
    }
    
    let pointYs:[CGFloat] =
        [0,0,0,0,0,2,-10,0,-2,5,-8,0,0,0,0,2,-10,0,-2,5,-8,0,0,0,0,0]
    
    var xScale:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        xScale = width / CGFloat( pointYs.count )
    }
    
    private func setup() {
        
        self.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(changeDrawingMode(_:)), name: Notification.Name.init(rawValue: XBDrawFrequecyDidChanged), object: nil)
        
    }
    
    @objc private func changeDrawingMode(_ aNote:Notification) {
        self.duration = (aNote.userInfo!["obj"] as! Double) == 0 ? 0.0 : 50.0 / (aNote.userInfo!["obj"] as! Double)
    }
    
    //MARK: - Draw ECG Graph 
    
    func animation4() {
        
        let r = CAReplicatorLayer()
        r.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        r.position = center
        r.backgroundColor = UIColor.gray.cgColor
        
        layer.addSublayer(r)
        
        let bar = CALayer()
        bar.bounds = r.bounds
        bar.position = r.position
        bar.backgroundColor = UIColor.red.cgColor
        bar.delegate = self
        bar.setNeedsDisplay()
        
        r.addSublayer(bar)
        
        let move = CABasicAnimation(keyPath: "position.x")
        move.toValue = bar.position.x - width
        move.duration = self.duration
        move.repeatCount = Float.infinity
        bar.add(move, forKey: nil)
        
        r.instanceCount = 2
        r.instanceTransform = CATransform3DMakeTranslation(width, 0.0, 0.0)
        r.masksToBounds = true
        
    }
    
    //MARK: -
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        
        ctx.setLineWidth(2)
        ctx.setLineJoin(.round)
        ctx.setStrokeColor(UIColor.black.cgColor)
        
        let path = UIBezierPath()
        
        let startY = pointYs.first!
        path.move(to: CGPoint(x:0, y:startY))
        
        for i in 1..<pointYs.count {
            path.addLine(to: CGPoint(x: CGFloat(i)*xScale, y: pointYs[i]))
        }
        
        var t = CGAffineTransform(a: 1, b: 0, c: 0, d: 3, tx: 0, ty: height * 0.5)
        let cgPath = path.cgPath.copy(using: &t)
        
        ctx.addPath(cgPath!)
        ctx.strokePath()
        
    }
    
    
}
