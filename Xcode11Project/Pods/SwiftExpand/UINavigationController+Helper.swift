//
//  UINavigationController+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/12/5.
//

import UIKit

@objc public extension UINavigationController{

    /// 传入控制器文件名称
    convenience init(vcName: String){
        self.init(rootViewController: UICtrFromString(vcName))
    }
}
