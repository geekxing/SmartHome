//
//  XBHealthCareViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/25.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBHealthCareViewController: XBBaseViewController {
    
    static let splitViewH          = CGFloat(69)
    
    private var singleVC:XBSingleSelectHealthHistoryController!
    private var multiVC:XBMultiSelectHealthHistoryController!
    
    private var bottomSearchView:UIView!
    private var searchButton:XBRoundedButton!
    
    private var realCurIndex = 0
    private var currenIndex = 0
    
    override var naviBackgroundImage: UIImage? {
        return UIImage(named: "RectHeader")
    }
    
    override var naviTitle: String? {
        return "健康档案"
    }
    
    private var childViews:[UIView] = []
    private var splitView:XBSplitView!
    private var scollView:UIScrollView!
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupSplitView()
        setupScrollView()
        setupBottomSearchView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        splitView.currentIndex = realCurIndex
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomSearchView.bottom = view.height
        searchButton.width = 92
        searchButton.centerX = bottomSearchView.width * 0.5
        searchButton.centerY = bottomSearchView.height * 0.5
    }

    //MARK: - UI Setting
    
    private func setupSplitView() {
        splitView = XBSplitView(titles: ["查询单次睡眠", "查询多次睡眠"])
        splitView.frame = CGRect(x: 0, y: naviBackgroundImage!.size.height*UIRate, width: view.width, height: XBHealthCareViewController.splitViewH)
        splitView.cornerRadius = 5
        for (index, button) in splitView.buttons.enumerated() {
            if index == 0 {
                button.setTitleColor(XB_DARK_TEXT, for: .normal)
                button.setBackgroundImage(UIImage.imageWith(UIColor.white), for: .normal)
            } else {
                button.setTitleColor(UIColor.white, for: .selected)
                button.setBackgroundImage(UIImage.imageWith(RGBA(r: 196, g: 190, b: 183, a: 1.0)), for: .selected)
            }
        }
        splitView.tapSplitButton = { [weak self] (index) in
            var offset = self!.scollView.contentOffset
            offset.x = CGFloat(index) * self!.scollView.width
            self!.scollView.setContentOffset(offset, animated: true)
        }
        view.addSubview(splitView)
    }
    
    private func setupScrollView() {
        
        scollView = UIScrollView(frame: CGRect(x:0, y:splitView.bottom-8, width:view.width, height:view.height-159))
        scollView.delegate = self
        scollView.backgroundColor = UIColor.white
        scollView.layer.cornerRadius = 5;
        view.addSubview(scollView)
        
        setupChildViewControllers()
        
        self.childViews = []
        for i in 0..<self.childViewControllers.count {
            let childView = self.childViewControllers[i].view
            self.childViews.append(childView!)
        }
        
        addChildViews()
        
    }

    private func setupChildViewControllers() {
        singleVC = XBSingleSelectHealthHistoryController()
        multiVC  = XBMultiSelectHealthHistoryController()
        
        self.addChildViewController(singleVC)
        self.addChildViewController(multiVC)
    }
    
    fileprivate func addChildViews() {
        
        let index = Int(scollView.contentOffset.x) / Int(scollView.width)
        currenIndex = index
        let childView = childViews[index]
        if childView.window == nil {
            childView.frame = scollView.bounds
            scollView.addSubview(childView)
        }
    }
    
    private func setupBottomSearchView() {
        
        bottomSearchView = UIView(frame: CGRect(x: 0, y: view.height-94*UIRate, width: view.width, height: 94*UIRate))
        bottomSearchView.backgroundColor = RGBA(r: 237, g: 238, b: 239, a: 1.0)
        view.addSubview(bottomSearchView)
        
        searchButton = XBRoundedButton(selector: #selector(clickSearchBtn(_:)), target: self, font: 18, title: "查询")
        bottomSearchView.addSubview(searchButton)
    }
    
    //MARK: - 按钮事件
    @objc private func clickSearchBtn(_ btn:UIButton) {
        realCurIndex = currenIndex
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: XBSearchSleepCareHistoryNotification), object: nil)
    }
    
}

extension XBHealthCareViewController: UIScrollViewDelegate {
    
    //UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.addChildViews()
    }
    
}