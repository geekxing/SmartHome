//
//  XBNetworking.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/11/25.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire

public typealias Parameters = [String: Any]

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
    
    
    func upload(_ images:[UIImage], url:String, maxLength:CGFloat, params:Parameters, success : @escaping (_ response : Parameters)->(), failture : @escaping (_ error : Error)->()) {
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                //遍历字典
                for (key, value) in params {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
                
                for i in 0..<images.count {
                    let data = images[i].compressImage(maxLength: 200)!
                    try! data.write(to: URL(fileURLWithPath: "/Users/laixiaobing/Desktop/211.png"))
                    multipartFormData.append(data, withName: "head", fileName: "image\(i)", mimeType: "image/jpeg")
                }
        },
            to: url,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? Parameters {
                            success(value)
                            let json = JSON(value)
                            debugPrint(json)
                        }
                    }
                case .failure(let encodingError):
                    debugPrint(encodingError)
                    failture(encodingError)
                }
        }
        )
        
    }

}
