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
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? String;
            if obj == nil {
                obj = String(describing: self.classForCoder);
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 闭包回调
    public func addAction(_ closure: @escaping (UIGestureRecognizer) -> Void) {
        objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        addTarget(self, action: #selector(p_invoke))
    }
    
    private func p_invoke() {
        let closure = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!) as! ((UIGestureRecognizer) -> Void)
        closure(self);
    }
    
}
