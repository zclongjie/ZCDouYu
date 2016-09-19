//
//  UIBarButtonItem-Extension.swift
//  ZCDouYu
//
//  Created by 赵隆杰 on 16/9/18.
//  Copyright © 2016年 赵隆杰. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    /*
     便利构造函数:
     1.convenience开头
     2.在构造函数中必须明确调用一个设计的构造函数(self)
    */
    convenience init(imageName : String, highImageName : String = "", size : CGSize = CGSizeZero) {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        }
        
        if size == CGSizeZero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPointZero, size: size)
        }
        
        self.init(customView : btn)
    }
}
