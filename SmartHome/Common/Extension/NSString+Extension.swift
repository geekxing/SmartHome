//
//  NSString+Extension.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/4/4.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import Foundation

extension String {
    
    func base64Encoding() -> String? {
        
        return self.data(using: .utf8)?.base64EncodedString()
        
    }

}
