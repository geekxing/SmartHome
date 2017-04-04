//
//  XBRelationNoticeController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/15.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Toast_Swift

class XBRelationNoticeController: XBBaseViewController {
    
    let token = XBLoginManager.shared.currentLoginData!.token
    
    override var naviBackgroundImage: UIImage? {
        return UIImage(named: "RectHeader")
    }
    
    override var naviTitle: String? {
        return "亲情关注"
    }

    private var splitView:XBSplitView!
    
    private var currentIndex:Int = -1;
    private var childViews:[UIView] = []
    
    private var applyConcernVC:XBApplyConcernViewController!
    private var concernMeVC:XBConcernMeViewController!
    private var myConcernMeVC:XBMyConcernViewController!
    private var scollView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setupSplitView()
        setupScrollView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    //MARK: - Public
    
    ///获取关注数据
    func getConcern(_ url:String , complete:@escaping ((_ data:JSON?, _ error:Error?)->())) {
        let params:Dictionary = ["token":token]
        
        XBNetworking.share.postWithPath(path: url, paras: params, success: {(result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code] != 1 {
                SVProgressHUD.showError(withStatus: message)
            }
            complete(json, nil)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            complete(nil, error)
        }
    }
    
    //MARK: - misc
    
//    private func makeTableData(_ json:JSON) {
//        let applyConcernJson = json[data]["applyConcern"].arrayValue
//        let concernMeJson = json[data]["concernMe"].arrayValue
//        let myConcernJson = json[data]["myConcern"].arrayValue
//        
//        deal(dataArary: &applyGroup, with: applyConcernJson, and: ApplyConcern)
//        deal(dataArary: &concernMe, with: concernMeJson, and: ConcernMe)
//        deal(dataArary: &myConcern, with: myConcernJson, and: MyConcern)
//    }
//    
//    private func deal(dataArary: inout [XBRelationConcernModel], with jsonArray:[JSON], and tag:String) {
//        let groupItem = XBTableGroupItem()
//        groupItem.headerTitle = tag
//        
//        for i in 0..<jsonArray.count {
//            let json = jsonArray[i]
//            let email = json["Email"].stringValue
//            self.checkUserExistInDB(userJson: json)
//            let user = XBUserManager.shared.user(uid: email)
//            
//            let model = XBRelationConcernModel()
//            model.tag = tag
//            model.user = user
//            dataArary.append(model)
//        }
//        groupItem.items = dataArary
//        tableGroups.append(groupItem)
//    }
    
    private func checkUserExistInDB(userJson:JSON) {
        XBUserManager.shared.addUser(userJson: userJson)
    }

    
    //MARK: - UI Setting
    
    private func setupSplitView() {
        splitView = XBSplitView(titles: ["申请关注", "我的关注", "关注我的"])
        splitView.frame = CGRect(x: 0, y: (naviBackgroundImage!.size.height*UIRate), width: view.width, height: 82)
        splitView.cornerRadius = 5
        splitView.tapSplitButton = { [weak self] (index) in
            if self?.currentIndex != index {
                self?.currentIndex = index
            } else {
            }
            var offset = self!.scollView.contentOffset
            offset.x = CGFloat(index) * self!.scollView.width
            self!.scollView.setContentOffset(offset, animated: true)
        }
        view.addSubview(splitView)
    }
    
    private func setupScrollView() {
        
        scollView = UIScrollView(frame: CGRect(x:0, y:splitView.bottom-13, width:view.width, height:view.height-159))
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
        applyConcernVC = XBApplyConcernViewController()
        myConcernMeVC = XBMyConcernViewController()
        concernMeVC = XBConcernMeViewController()
        
        self.addChildViewController(applyConcernVC)
        self.addChildViewController(myConcernMeVC)
        self.addChildViewController(concernMeVC)
    }
    
    fileprivate func addChildViews() {
        
        let index = Int(scollView.contentOffset.x) / Int(scollView.width)
        let childView = childViews[index]
        if childView.window == nil {
            childView.frame = scollView.bounds
            scollView.addSubview(childView)
        }
    }
    
}

extension XBRelationNoticeController: UITableViewDelegate {
    //UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.addChildViews()
    }
    
}
