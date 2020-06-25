//
//  UINavigationController+Hook.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/12/13.
//  Copyright © 2018 BN. All rights reserved.
//

import UIKit

@objc extension UINavigationController{
    
    public func hook_pushViewController(_ viewController: UIViewController, animated: Bool) {
        //需要注入的代码写在此处
//        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil);
        viewController.view.backgroundColor = .white;
        //判断是否是根控制器
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            _ = viewController.createBackItem(UIImageNamed("icon_arowLeft_black")!)
//            DDLog(viewController.navigationItem.leftBarButtonItem)
        }
        //push进入下一个控制器
        hook_pushViewController(viewController, animated: animated);
    }
    
    /// 修改切换导航栏样式
    public func changeBarStyle() {
         // 切换导航栏样式
         if navigationBar.barStyle == .default {
             navigationBar.barStyle = .black
         } else {
             navigationBar.barStyle = .default
         }
    }
    

    
}
