//
//  UIGestureRecognizer+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2018/12/23.
//

import UIKit

@objc extension UIGestureRecognizer{
    
    /// 方法名称(用于自定义)
    public var funcName: String {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? String;
            if obj == nil {
                obj = String(describing: self.classForCoder);
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 闭包回调
    public func addAction(_ closure: @escaping (UIGestureRecognizer) -> Void) {
        let runtimeKey = RuntimeKeyFromSelector(self, aSelector: #selector(addAction(_:)))
        objc_setAssociatedObject(self, runtimeKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        addTarget(self, action: #selector(p_invoke))
    }
    
    private func p_invoke() {
        let runtimeKey = RuntimeKeyFromSelector(self, aSelector: #selector(addAction(_:)))
        if let closure = objc_getAssociatedObject(self, runtimeKey) as? ((UIGestureRecognizer) -> Void) {
            closure(self);
        }
    }
    
}
