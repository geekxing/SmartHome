//
//  UIImageView+Extension.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/1.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setHeader(url:String?, uid:String) {
        if let imageUrl = url {
            let placeholder = XBUserManager.shared.placeholderForUser(uid: uid)
            self.sd_setImage(with: URL(string: imageUrl),
                             placeholderImage:placeholder,
                             options: .retryFailed,
                             completed: { (image, err, _, _) in
                                if (image != nil && err == nil) {
                                    DispatchQueue.global().async(execute: {
                                        let headerImage = image?.circleImage()
                                        DispatchQueue.main.async(execute: {
                                            self.image = headerImage
                                        })
                                    })
                                }
            })
        }
    }
    
}
