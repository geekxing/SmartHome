//
//  XBSingleReportView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/23.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import Charts

class XBSingleReportView: UIView {
    
    //MARK: - Properties
    let drawHeight = CGFloat(145.0)  //Debug测得的实际绘图区域高度
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    var beginValue = -1
    var lineDataSet:LineChartDataSet?
    var lineData:LineChartData?
    
    private(set) var maxPoint = 0
    private(set) var avgPoint = 0
    private(set) var lowPoint = 0
    private(set) var xScale = CGFloat(0.0)
    private(set) var yScale = CGFloat(0.0)
    private(set) var pointYs = [Double]()
    
    private var maxButton:UIButton!
    private var avgButton:UIButton!
    private var minButton:UIButton!
    var lineChart:LineChartView!
    
    var datas = [0.0] {
        didSet {
            if datas.count != 0 {
                
                xScale = (self.width-90)/CGFloat(datas.count) //比例：宽度/x轴分度
                maxPoint = Int(maxOf(numbers: datas))
                avgPoint = Int(averageOf(numbers: datas))
                lowPoint = Int(minOf(numbers: datas))
                if beginValue == -1 {
                    beginValue = lowPoint
                }
                //算出y轴最值
                let maxY = max(lineChart.leftAxis.axisMaximum, lineChart.rightAxis.axisMaximum, Double(maxPoint))
                yScale = drawHeight / CGFloat(maxY-Double(beginValue)) //比例：高度/y轴分度
                for value in datas {
                    let newValue = value - Double(beginValue)
                    pointYs.append(newValue)
                }
                setChartData()
                drawLimitLine()
                
                maxButton.setAttributedTitle(self.makeScoreAttributeString(score: "\(maxPoint)", text: danwei), for: .normal)
                maxButton.sizeToFit()
                avgButton.setAttributedTitle(self.makeScoreAttributeString(score: "\(avgPoint)", text: danwei), for: .normal)
                avgButton.sizeToFit()
                minButton.setAttributedTitle(self.makeScoreAttributeString(score: "\(lowPoint)", text: danwei), for: .normal)
                minButton.sizeToFit()
                //setNeedsDisplay()
            }
        }
    }
    
    var danwei:String = ""
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.left = 22
        titleLabel.top  = 22
        
        ///Chart最小值与绘图框的默认padding为10
        let padding = height - 39
        minButton.right = width - 25
        minButton.centerY = padding - CGFloat(lowPoint-beginValue) * yScale
        avgButton.right = width - 25
        avgButton.centerY = padding - CGFloat(avgPoint-beginValue) * yScale
        maxButton.right = width - 25
        maxButton.centerY = padding - CGFloat(maxPoint-beginValue) * yScale
        
        lineChart.width = maxButton.centerX - titleLabel.left - 5
        lineChart.height = drawHeight + 20
        lineChart.left = 22
        lineChart.top = 50
    }
    
    //MARK: - Setup
    func setup() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 23
        self.layer.masksToBounds = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = XB_DARK_TEXT
        addSubview(titleLabel)
        makeChart()
        
        maxButton = makeButton(#imageLiteral(resourceName: "up"))
        avgButton = makeButton(#imageLiteral(resourceName: "mid"))
        minButton = makeButton(#imageLiteral(resourceName: "down"))
        addSubview(maxButton)
        addSubview(avgButton)
        addSubview(minButton)
    }
    
    //MARK: - 画图
    private func makeChart() {
        lineChart = LineChartView()
        addSubview(lineChart)
        lineChart.backgroundColor = UIColor.white
        lineChart.noDataText = "暂无数据"
        lineChart.scaleYEnabled = false
        lineChart.scaleXEnabled = false
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
        lineChart.dragEnabled = false
        lineChart.xAxis.enabled = false
        lineChart.leftAxis.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.chartDescription?.text = "" //描述
        lineChart.legend.enabled = false  //图例说明
        lineChart.animate(yAxisDuration: 1.0)
    }
    
    func drawLimitLine() {
        let ll1 = ChartLimitLine(limit: Double(maxPoint-beginValue))
        ll1.lineDashLengths = [1,3]
        ll1.lineColor = UIColorHex("343434", 1)
        
        let ll2 = ChartLimitLine(limit: Double(avgPoint-beginValue))
        ll2.lineDashLengths = [1,3]
        ll2.lineColor = UIColorHex("343434", 1)
        
        let ll3 = ChartLimitLine(limit: Double(lowPoint - beginValue))
        ll3.lineDashLengths = [1,3]
        ll3.lineColor = UIColorHex("343434", 1)
        
        var yAxis:YAxis?
        let rightYAxis = lineChart.rightAxis
        yAxis = rightYAxis.enabled ? rightYAxis : lineChart.leftAxis
        yAxis!.removeAllLimitLines()
        yAxis!.addLimitLine(ll1)
        yAxis!.addLimitLine(ll2)
        yAxis!.addLimitLine(ll3)
        rightYAxis.axisMaximum = ll1.limit
        rightYAxis.axisMinimum = ll3.limit
        rightYAxis.drawZeroLineEnabled = false
        rightYAxis.drawGridLinesEnabled = false
    }
    
    //MARK: - 图表数据
    private func setChartData() {
        
        var yVals = [ChartDataEntry]()
        for i in 0..<pointYs.count {
            yVals.append(ChartDataEntry(x: Double(CGFloat(i) * xScale), y: Double(pointYs[i])))
        }
        
        let dataSet = LineChartDataSet(values: yVals, label: "")
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.setColor(UIColor.black)
        lineDataSet = dataSet
        
        lineData = LineChartData(dataSet: dataSet)
        lineData!.setDrawValues(false)
        lineChart.data = lineData
    }
    
    //MARK: - misc
    private func makeButton(_ img:UIImage) -> UIButton {
        let btn = UIButton()
        btn.setImage(img, for: .normal)
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        return btn
    }
    
    private func makeScoreAttributeString(score:String, text:String) -> NSAttributedString {
        let scoreAttri = NSMutableAttributedString(string: score, attributes: [NSFontAttributeName:UIFontSize(size: 20)])
        let textAttri = NSMutableAttributedString(string: "\n\(text)", attributes: [NSFontAttributeName:UIFontSize(size: 12)])
        scoreAttri.append(textAttri)
        return scoreAttri
    }


}
