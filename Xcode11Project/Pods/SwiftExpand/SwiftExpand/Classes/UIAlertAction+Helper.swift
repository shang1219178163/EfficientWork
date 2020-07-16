//
//  UIAlertAction+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/1/16.
//

import UIKit

@objc public extension UIAlertAction{
    
    var tag: Int {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? Int {
                return obj
            }
            return 1
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 设置UIAlertController按钮颜色
    func setTitleColor(_ color: UIColor = .theme) {
        setValue(color, forKey: kAlertActionColor);
    }
    
}
