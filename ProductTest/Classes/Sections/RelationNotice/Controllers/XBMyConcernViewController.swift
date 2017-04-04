//
//  XBMyConcernViewController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/2/20.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class XBMyConcernViewController: XBConcernMeViewController {
    
    var myConcern:[XBRelationConcernModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
    override func registerCell() {
        tableView.register(XBMyConcernCell.self, forCellReuseIdentifier: MyConcern)
    }
    
    
    //MARK: - Operations
    override func loadData() {
        if self.parent!.isKind(of: XBRelationNoticeController.self) {
            let parentVc = self.parent as! XBRelationNoticeController
            parentVc.getConcern(GET_MYCONCERN, complete: {[weak self] (data, _) in
                if let json = data {
                    if json[Code] == 1 {
                        self?.myConcern.removeAll()
                        let array = json[XBData].arrayValue
                        var dataArray = [XBRelationConcernModel]()
                        for userData in array {
                            let email = userData["email"].stringValue
                            XBUserManager.shared.addUser(userJson: userData)
                            let user = XBUserManager.shared.user(uid: email)
                            let model = XBRelationConcernModel()
                            model.user = user
                            model.tag = MyConcern
                            dataArray.append(model)
                        }
                        self?.myConcern = dataArray
                        self?.tableView.mj_header.endRefreshing()
                        self?.reload()
                    }
                }
            })
        }
    }

}

extension XBMyConcernViewController {
    
    //MARK: - Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return myConcern.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model:XBRelationConcernModel!
        model = myConcern[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyConcern) as! XBMyConcernCell
        cell.clickArrowButton = {[weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.clickCancelButton = {[weak self] user in
            self?.cancelAlert(user.email!, type:"myConcern")
        }
        
        cell.model = model
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = myConcern[indexPath.row]
        if model.open == true {
            return 188;
        }
        return 71;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0;
    }
    
}
