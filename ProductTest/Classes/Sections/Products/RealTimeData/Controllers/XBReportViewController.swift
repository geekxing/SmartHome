//
//  XBReportViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/12.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftDate
import SVProgressHUD
import SwiftyJSON

class XBReportViewController: XBBaseViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ringView: XBRingView!
    @IBOutlet weak var heatRateButton: XBSquareButton!
    @IBOutlet weak var breathButton: XBSquareButton!
    @IBOutlet weak var fanshenButton: XBSquareButton!
    @IBOutlet weak var qiyeButton: XBSquareButton!
    @IBOutlet weak var sleepTimeLineView: XBSliderView!
    @IBOutlet weak var getupButton: XBSquareButton!
    @IBOutlet weak var sleepButton: XBSquareButton!
    @IBOutlet weak var deepSleepView: XBSliderView!
    @IBOutlet weak var deepSleepLabel: UILabel!
    @IBOutlet weak var sleepView: XBSliderView!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var totalSleepView: XBSliderView!
    @IBOutlet weak var totalSleepLabel: UILabel!
    
    var model:XBSleepData?
    var timer:Timer?
    var triggerTime = 0
    
    override var naviBackgroundImage: UIImage? {
        return UIImage(named: "RectHeader")
    }
    
    override var naviTitle: String? {
        return "检测报告"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        setupTopPart()
        setupBottomPart()
        scrollView.contentSize = CGSize(width: view.width, height: totalSleepView.bottom + 50)
        setValueForUI()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func beginAnimate() {
        timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(changeProgressValue), userInfo: nil, repeats: true)
    }
    
    
    //MARK: - Setup UI
    
    private func setupTopPart() {
        
        self.dateLabel.font = UIFont.boldSystemFont(ofSize: 18*UIRate)
        self.ringView.strokeWidth = 10*UIRate
        self.ringView.width = self.ringView.height
        self.ringView.strokeColor = RGBA(r: 82, g: 83, b: 74, a: 1)
        
        heatRateButton.setTitle("平均心率", for: .normal)
        breathButton.setTitle("平均呼吸率", for: .normal)
        fanshenButton.setTitle("翻身次数", for: .normal)
        qiyeButton.setTitle("起夜次数", for: .normal)
        
    }
    
    private func setupBottomPart() {
        
        self.pileRoundButton(btn: sleepButton, text: "上床")
        self.pileRoundButton(btn: getupButton, text: "起床")
        
        self.pileSliderView(slider: sleepTimeLineView,
                            width: 18,
                            leftColor: UIColorHex("edebea", 1),
                            rightColor:  UIColorHex("c6bdb5", 1),
                            dotImage: #imageLiteral(resourceName: "dot1"),
                            tagText: "入眠")
        
        self.pileSliderView(slider: deepSleepView,
                            width: 18,
                            leftColor: UIColorHex("65655c", 1),
                            rightColor:  UIColor.white ,
                            dotImage: #imageLiteral(resourceName: "dot2"),
                            tagText: "深睡")
        
        self.pileSliderView(slider: sleepView,
                            width: 18,
                            leftColor: UIColorHex("8a847f", 1),
                            rightColor:  UIColor.white,
                            dotImage: #imageLiteral(resourceName: "dot3"),
                            tagText: "浅睡")
        
        self.pileSliderView(slider: totalSleepView,
                            width: 18,
                            leftColor: UIColorHex("c6bdb5", 1),
                            rightColor: UIColor.white,
                            dotImage: #imageLiteral(resourceName: "dot4"),
                            tagText: "总长")

        
    }
    
    @objc private func changeProgressValue() {
        self.triggerTime += 1
        if self.triggerTime <= 60 {
            self.ringView.progress += ringView.increment
            self.sleepTimeLineView.progress += sleepTimeLineView.increment
            self.deepSleepView.progress += deepSleepView.increment
            self.sleepView.progress += sleepView.increment
            self.totalSleepView.progress += totalSleepView.increment
        } else {
            self.triggerTime = 0
            timer?.invalidate()
        }
    }
    
    private func pileRoundButton(btn:XBSquareButton, text:String) {
        btn.setImage(#imageLiteral(resourceName: "dot0"), for: .normal)
        btn.subTitleLabel.text = text
        btn.subTitleLabel.textColor = UIColor.black
        btn.subTitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        btn.subTitleRatioToImageView = 0.2
        btn.subTitleLabel.centerY = sleepButton.imageView!.centerY
    }
    
    private func pileSliderView(slider:XBSliderView, width:CGFloat, leftColor:UIColor, rightColor:UIColor, dotImage:UIImage, tagText:String) {
        slider.trackWidth = width
        slider.rightTrackColor = rightColor
        slider.leftTrackColor = leftColor
        slider.thumbnailButton.setImage(dotImage, for: .normal)
        slider.thumbnailButton.subTitleLabel.text = tagText
    }

    private func makeScoreAttributeString(score:String, text:String) -> NSAttributedString {
        
        let bigSize = SCREEN_WIDTH >= 375 ? 18 : 17
        let smallSize = SCREEN_WIDTH >= 375 ? 9 : 8
        
        let scoreAttri = NSMutableAttributedString(string: score,
                                                   attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: CGFloat(bigSize)),
                                                                NSForegroundColorAttributeName:UIColor.white])
        let textAttri = NSMutableAttributedString(string: "\n\(text)",
            attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: CGFloat(smallSize)),
                         NSForegroundColorAttributeName:UIColor.white])
        scoreAttri.append(textAttri)
        return scoreAttri
    }
    
    
    //MARK: - Setter
    
    func setValueForUI() {
        
        if let model = self.model {
            
            let date = Date(timeIntervalSince1970: model.creatTime)
            self.dateLabel.text = "检测日期：\(date.month)月\(date.day)日"
            self.dateLabel.sizeToFit()
            self.ringView.maxValue = CGFloat(model.score)/100.0
            self.ringView.increment = self.ringView.maxValue/60
            
            self.heatRateButton.subTitleLabel.attributedText = self.makeScoreAttributeString(score:"\(model.avgHeart)", text: "次/分")
            self.breathButton.subTitleLabel.attributedText = self.makeScoreAttributeString(score:"\(model.avgBreath)", text: "次/分")
            self.fanshenButton.subTitleLabel.attributedText = self.makeScoreAttributeString(score:"\(model.turnNum)", text: "次")
            self.qiyeButton.subTitleLabel.attributedText = self.makeScoreAttributeString(score:"\(model.outNum)", text: "次")
            
            let gotoBed = Date(timeIntervalSince1970: model.goToBed)
            let getup = Date(timeIntervalSince1970: model.outOfBed)
            let sleep = Date(timeIntervalSince1970: model.sleepStart)
            let timeGap = model.outOfBed - model.goToBed ///上床->起床
            let fallSleepGap = model.sleepStart - model.goToBed ///上床->睡眠
            
            if timeGap != 0 {
                self.sleepTimeLineView.maxValue = max(CGFloat(fallSleepGap / timeGap), 0.2)
                self.sleepTimeLineView.increment = self.sleepTimeLineView.maxValue/60
                self.sleepTimeLineView.thumbnailButton.setTitle("\(sleep.hour):\(sleep.minute)", for: .normal)
            }
            
            self.sleepButton.setTitle("\(gotoBed.hour):\(gotoBed.minute)", for: .normal)
            self.getupButton.setTitle("\(getup.hour):\(getup.minute)", for: .normal)
            
            let gap = model.deepSleepTime+model.lightSleepTime
            if gap != 0 {
                
                let timeCmp = XBOperateUtils.timeComps(gap)
                self.totalSleepView.maxValue = 1
                self.totalSleepView.increment = self.totalSleepView.maxValue/60
                self.totalSleepLabel.text = "总睡眠时长：\(timeCmp.hour)小时\(timeCmp.minute)分"
                self.totalSleepLabel.sizeToFit()
                
                let timeCmp2 = XBOperateUtils.timeComps(model.deepSleepTime)
                self.deepSleepView.maxValue = CGFloat(model.deepSleepTime / gap)
                self.deepSleepView.increment = self.deepSleepView.maxValue/60
                self.deepSleepLabel.text = "深度睡眠时长：\(timeCmp2.hour)小时\(timeCmp2.minute)分"
                self.deepSleepLabel.sizeToFit()
                
                let timeCmp3 = XBOperateUtils.timeComps(model.lightSleepTime)
                self.sleepView.maxValue = CGFloat(model.lightSleepTime / gap)
                self.sleepView.increment = self.sleepView.maxValue/60
                self.sleepLabel.text = "浅度睡眠时长：\(timeCmp3.hour)小时\(timeCmp3.minute)分"
                self.sleepLabel.sizeToFit()
                
            }
            
            self.beginAnimate()
            
        }
        
        
    }
    

}
