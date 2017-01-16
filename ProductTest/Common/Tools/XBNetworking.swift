//
//  XBNetworking.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/25.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON

class XBNetworking: NSObject {
    static let share = XBNetworking()
    var session:URLSession!
    
    override init() {
        super.init()
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0   //设置请求超时5秒
        session = URLSession.init(configuration: sessionConfig)
    }
    
    // MARK:- GET
    func getWithPath(path: String,paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        
        var i = 0
        var address = path
        if let paras = paras {
            
            for (key,value) in paras {
                
                if i == 0 {
                    
                    address += "?\(key)=\(value)"
                }else {
                    
                    address += "&\(key)=\(value)"
                }
                
                i += 1
            }
        }
        
        let url = URL(string: address.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let dataTask = session.dataTask(with: url!) { (data, respond, error) in
            
            if let data = data {
                
                let json = JSON(data: data)
                DispatchQueue.main.async(execute: {
                    success(json)
                })
            }else {
                DispatchQueue.main.async(execute: {
                    failure(error!)
                })
            }
        }
        dataTask.resume()
    }
    
    // MARK:- POST
    func postWithPath(path: String,paras: Dictionary<String,Any>?,success: @escaping ((_ result: Any) -> ()),failure: @escaping ((_ error: Error) -> ())) {
        
        var i = 0
        var address: String = ""
        
        if let paras = paras {
            
            for (key,value) in paras {
                
                if i == 0 {
                    
                    address += "\(key)=\(value)"
                }else {
                    
                    address += "&\(key)=\(value)"
                }
                
                i += 1
            }
        }
        let url = URL(string: path)
        var request = URLRequest.init(url: url!)
        request.httpMethod = "POST"
        print(address)
        request.httpBody = address.data(using: .utf8)
        let dataTask = session.dataTask(with: request) { (data, respond, error) in
            
            if let data = data {
                let json = JSON(data: data)
                DispatchQueue.main.async(execute: {
                    success(json)
                })
                
            }else {
                
                DispatchQueue.main.async(execute: {
                    failure(error!)
                })
            }
        }
        dataTask.resume()
    }

}
