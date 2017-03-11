//
//  UIImageView+Extension.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/1.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setHeader(url:String?) {
        if let imageUrl = url {
            self.sd_setImage(with: URL.init(string: imageUrl),
                             placeholderImage: UIImage(named: "avatar_male")?.circleImage(),
                             options: .retryFailed,
                             completed: { (image, err, _, _) in
                                self.image = image?.circleImage()
            })
        }
    }
    
}
