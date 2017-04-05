//
//  XBSleepHistoryTableCell.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/26.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBSleepHistoryTableCell: UITableViewCell {
    
    static let textColor = UIColorHex("777777", 1.0)
    
    private let dateLabel = UILabel()
    private let hourLabel = UILabel()
    private let hourTextLabel = UILabel()
    private let scoreLabel = UILabel()
    
    var model:XBSleepData? {
        didSet {
            //self.isSelected = model!.selected
            dateLabel.text = model?.date
            dateLabel.sizeToFit()
            hourLabel.text = model?.time
            hourLabel.sizeToFit()
            scoreLabel.text = model?.score
            scoreLabel.sizeToFit()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Setup
    private func setup() {
        commonInit(label: dateLabel, font: 14)
        commonInit(label: hourLabel, font: 17)
        commonInit(label: hourTextLabel, font: 12)
        commonInit(label: scoreLabel, font: 16)
        
        hourTextLabel.text = "小时"
        hourTextLabel.sizeToFit()
    }
    
    private func commonInit(label:UILabel, font:CGFloat) {
        label.font = UIFontSize(size: font)
        label.textColor = XBSleepHistoryTableCell.textColor
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.left = 25.0*UIRate
        dateLabel.centerY = height * 0.5
        hourLabel.bottom = height * 0.5
        hourLabel.centerX = width * 0.5
        hourTextLabel.top = height * 0.5
        hourTextLabel.centerX = width * 0.5
        scoreLabel.centerX = floor(width*5/6)
        scoreLabel.centerY = height * 0.5
    }

}