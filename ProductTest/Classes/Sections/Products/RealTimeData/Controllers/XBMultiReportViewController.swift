//
//  XBMultiReportViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/23.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBMultiReportViewController: XBBaseViewController {
    
    //MARK: - Properties
    let scrollView  = XBMultiReportView()
    var viewArray = [XBSingleReportView]()
    let titles = ["心率","呼吸率","深度睡眠时长","睡眠质量曲线"]
    let danweis = ["次/分","次/分","时","分"]
    let datas1 = [70.0,74,68,76,70,71]
    let datas2 = [15,20,16.5,19.5,15.5]
    let datas3 = [5.0,7.3,5.0,9.0,3.0]
    let datas3B = [7.0,10.0,6.0,11.0,7.0]
    var beginDate:Date?
    var endDate:Date?
    var count = 8

    //MARK: - Overrides
    override var naviBackgroundImage: UIImage? {
        return UIImage(named: "RectHeader")
    }
    
    override var naviTitle: String? {
        return "统计分析"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        scrollView.frame = CGRect(x: 0, y: naviBackgroundImage!.size.height * UIRate, width: view.width, height: view.height)
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.width, height: 1270)
        
        for i in 0..<4 {
            var report:XBSingleReportView!
            if i == 2 {
                report = XBDoubleSetLineView(frame:CGRect(x: 0, y: 128 + i * (244+19), width: Int(view.width), height: 244))
            } else {
                report = XBSingleReportView(frame:CGRect(x: 0, y: 128 + i * (244+19), width: Int(view.width), height: 244))
            }
            let shawdow = UIImageView(image: #imageLiteral(resourceName: "shadowR"))
            shawdow.left = 0
            shawdow.top = report.bottom
            shawdow.width = view.width
            
            scrollView.addSubview(report)
            scrollView.addSubview(shawdow)
            
            viewArray.append(report)
            report.tag = i
        }
        
        makeData()
    }
    
    //MARK: - Private
    private func makeData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
            self.scrollView.beginDate = self.beginDate
            self.scrollView.endDate = self.endDate
            self.scrollView.count = self.count
            
        })
        
        for report in viewArray {
            let i = report.tag
            report.title = titles[i]
            report.danwei = danweis[i]
        }
        viewArray[0].datas = datas1
        viewArray[1].datas = datas2
        let doubleSetView = viewArray[2] as! XBDoubleSetLineView
        doubleSetView.beginValue = 0
        doubleSetView.datas = datas3
        doubleSetView.datasB = datas3B
    }
    

}
