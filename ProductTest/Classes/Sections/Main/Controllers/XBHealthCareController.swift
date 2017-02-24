//
//  XBHealthCareController.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2016/12/5.
//  Copyright © 2016年 helloworld.com. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class XBHealthCareController: UIViewController {
    static let ip = "192.168.1.1"
    static let port:UInt16 = 8002
    
    var closeBtn:UIButton!
    var displayTextView:UITextView!
    var socket:GCDAsyncSocket?

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        view.backgroundColor = UIColor.white
        closeBtn = UIButton.init(image: nil, backImage:nil, color: UIColor.blue, target: self, sel: #selector(disconnect), title: "disconnect")
        closeBtn.frame = CGRect(x: 140, y: 50, width: 100, height: 40)
        view.addSubview(closeBtn)
        
        displayTextView = UITextView(frame: CGRect(x: 20, y: 100, width: view.width - 40, height: 500))
        displayTextView.backgroundColor = UIColor.lightGray
        displayTextView.isUserInteractionEnabled = false
        view.addSubview(displayTextView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        connect()
    }
    
    private func connect() {
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try socket?.connect(toHost: XBHealthCareController.ip, onPort: XBHealthCareController.port)
            addText(text: "ip:"+XBHealthCareController.ip+"\tport:"+"\(XBHealthCareController.port)")
            addText(text: "connect successfully")
        } catch _ {
            addText(text: "connect failed")
        }
    }
    
    @objc private func disconnect() {
        socket?.disconnect()
        addText(text: "disconnect.")
    }
    
    func addText(text:String) {
        displayTextView.text = displayTextView.text.appendingFormat("%@\n",text)
    }
    
}

extension XBHealthCareController:GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        addText(text: "connect to"+host)
        socket?.readData(withTimeout: 5.0, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let msg = String(data: data, encoding: .utf8)
        addText(text: msg!)
        socket?.readData(withTimeout: 5.0, tag: 0)
    }
}
