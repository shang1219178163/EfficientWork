//
//  UIBarButtonItem+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/28.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc extension UIBarButtonItem{
    
    public var systemType: UIBarButtonItem.SystemItem {
        get {
            return objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as! UIBarButtonItem.SystemItem;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 按钮是否显示
    public func setHidden(_ hidden: Bool) {
        isEnabled = !hidden;
        tintColor = !hidden ? UIColor.theme : UIColor.clear;
    }

    /// 创建 UIBarButtonItem
    public static func create(_ obj: String, style: UIBarButtonItem.Style = .plain, target: Any? = nil, action: Selector? = nil) -> UIBarButtonItem{
        if let image = UIImage(named: obj) {
            return UIBarButtonItem(image: image, style: style, target: target, action: action)
        }
        return UIBarButtonItem(title: obj, style: style, target: target, action: action);
    }
    
    /// UIBarButtonItem 回调
    public func addAction(_ closure: @escaping (UIBarButtonItem) -> Void) {
        let runtimeKey = RuntimeKeyFromSelector(self, aSelector: #selector(addAction(_:)))
        objc_setAssociatedObject(self, runtimeKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        target = self;
        action = #selector(p_invoke);
    }
    
    private func p_invoke() {
        let runtimeKey = RuntimeKeyFromSelector(self, aSelector: #selector(addAction(_:)))
        if let closure = objc_getAssociatedObject(self, runtimeKey) as? ((UIBarButtonItem) -> Void) {
            closure(self);
        }
    }

}
