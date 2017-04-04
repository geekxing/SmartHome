//
//  XBHealthCareHeaderView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/25.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit


class XBHealthCareHeaderView: UIView {
    
    public enum XBHealthCareHeaderViewSelectType : Int {
        
        
        case single
        
        case multiple
        
    }
    
    static let outerMargin = (25.0*UIRate)
    static let interMargin = (54.0*UIRate)
    
    var beginDate = Date(timeIntervalSinceNow: -7*24*3600) //一周前
    var endDate = Date()
    
    private let areaWidth   = (SCREEN_WIDTH - 2*outerMargin - 2*interMargin)/3

    private var selectType:XBHealthCareHeaderViewSelectType?
    
    private var selectViewA:XBDateSelectView?
    private var selectViewB:XBDateSelectView?
    private var toLabel = UILabel()
    
    private var shawdowLine:UIImageView!
    private var container:UIView!

    private var titles = ["测试日期", "睡眠时长", "睡眠评分"]
    private var tipLabels = [UILabel]()
    
    convenience init(_ type:XBHealthCareHeaderViewSelectType) {
        self.init()
        selectType = type
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.width = self.width
        container.height = 48
        container.left = 0
        container.bottom = height
        
        for (index, label) in self.tipLabels.enumerated() {
            label.left = XBHealthCareHeaderView.outerMargin+CGFloat(index)*(areaWidth+XBHealthCareHeaderView.interMargin)
            label.centerY = container.height * 0.5
        }
        
        shawdowLine.width = width
        shawdowLine.height = 8;
        shawdowLine.left = 0;
        shawdowLine.top  = container.height;
        
        toLabel.centerX = width * 0.5
        toLabel.centerY = (height - 48.0) * 0.5
    }
    
    //MARK: - Public
    func setDate(_ date:Date, for oldDate:inout Date) {
        if self.selectType == .single {
            oldDate = date
            selectViewA?.date = date
        } else {
            if oldDate == self.endDate {
                selectViewB?.date = date
            } else {
                selectViewA?.date = date
            }
        }
    }
    
    //MARK: - Setup
    
    private func setup() {
        if selectType == .single {
            selectViewA = XBDateSelectView(frame: CGRect(x: 0, y: 25.0, width: self.width, height: 33.0))
            selectViewA?.date = endDate
            selectViewA?.labelTextColor = UIColorHex("595757", 1.0)
            addSubview(selectViewA!)
            selectViewA?.didPickDateBlock = { [weak self] date in
                self?.endDate = date
            }
        } else {
            backgroundColor = RGBA(r: 196, g: 190, b: 183, a: 1.0)
            selectViewA = XBDateSelectView(frame: CGRect(x: 0, y: 25.0, width: self.width, height: 33.0))
            selectViewA?.date = beginDate
            selectViewA?.labelTextColor = UIColorHex("ffffff", 1.0)
            addSubview(selectViewA!)
            selectViewA?.didPickDateBlock = { [weak self] date in
                self?.beginDate = date
            }
            
            toLabel.text = "至"
            toLabel.font = UIFont.boldSystemFont(ofSize: 18)
            toLabel.textColor = UIColorHex("ffffff", 1.0)
            toLabel.sizeToFit()
            addSubview(toLabel)
            
            selectViewB = XBDateSelectView(frame: CGRect(x: 0, y: selectViewA!.bottom+40, width: self.width, height: 33.0))
            selectViewB?.date = endDate
            selectViewB?.labelTextColor = UIColorHex("ffffff", 1.0)
            addSubview(selectViewB!)
            selectViewB?.didPickDateBlock = { [weak self] date in
                self?.endDate = date
            }
            
        }
        
        setupContainer()
    }
    
    private func setupContainer() {
        container = UIView(frame: CGRect())
        container.backgroundColor = UIColor.white
        addSubview(container)
        setupLabel()
        setupShadow()
    }
    
    private func setupShadow() {
        shawdowLine = UIImageView(image: UIImage(named: "horizontalShadow"))
        container.addSubview(shawdowLine)
    }
    
    private func setupLabel() {
        for (title) in titles {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = XB_DARK_TEXT
            label.text = title
            label.sizeToFit()
            tipLabels.append(label)
            container.addSubview(label)
        }
    }
    

    
}
