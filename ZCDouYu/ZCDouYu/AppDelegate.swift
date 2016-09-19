//
//  AppDelegate.swift
//  ZCDouYu
//
//  Created by 赵隆杰 on 16/9/18.
//  Copyright © 2016年 赵隆杰. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        return true
    }

}

