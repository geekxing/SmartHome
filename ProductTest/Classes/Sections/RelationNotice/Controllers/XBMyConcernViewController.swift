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
            parentVc.getConcern(complete: {[weak self] (success) in
                self?.tableGroups.removeAll()
                self?.tableGroups.append(parentVc.tableGroups[2])
                self?.reload()
            })
        }
    }
    
    ///删除我关注的人
    
    fileprivate func cancelAlert(otherEmail:String) {
        let vc = XBAlertController(title: "确定不再关注此人？", message: "")
        vc.clickAction = { [weak self] index in
            switch index {
            case 0: self?.cancelConcern(otherEmail: otherEmail)
            default: break
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func cancelConcern(otherEmail:String) {
        let params:Dictionary = ["myEmail":loginUser!.Email!,
                                 "otherEmail":otherEmail,
                                 "flog":"true" ]
        let url = baseRequestUrl + "concern/cancel"
        XBNetworking.share.postWithPath(path: url, paras: params, success: { [weak self](result) in
            let json = result as! JSON
            debugPrint(json)
            let message = json[Message].stringValue
            if json[Code].intValue == cancelNotice {
                SVProgressHUD.showSuccess(withStatus: message)
                self?.loadData()
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }

}

extension XBMyConcernViewController {
    
    //MARK: - Datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model:XBRelationConcernModel!
        let group = tableGroups[indexPath.section]
        model = group.items[indexPath.row] as? XBRelationConcernModel
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyConcern) as! XBMyConcernCell
        cell.clickArrowButton = {[weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.clickCancelButton = {[weak self] user in
            self?.cancelAlert(otherEmail: user.Email!)
        }
        
        cell.model = model
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group = tableGroups[indexPath.section]
        let model = group.items[indexPath.row] as? XBRelationConcernModel
        if model?.open == true {
            return 188;
        }
        return 71;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0;
    }
    
}
