//
//  Hook.swift
//  SwiftTemplet
//
//  Created by dev on 2018/12/11.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension NSObject{
    
    static func swizzleMethodInstance(_ clz: AnyClass, origSel: Selector, replSel: Selector) -> Bool {
        
        let oriMethod = class_getInstanceMethod(clz, origSel);
        let repMethod = class_getInstanceMethod(clz, replSel);
        if oriMethod == nil ||  repMethod == nil {
            print("Swizzling Method(s) not found while swizzling class \(NSStringFromClass(classForCoder())).")
            return false;
        }
        //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(clz, origSel, method_getImplementation(repMethod!), method_getTypeEncoding(repMethod!))
        //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        if didAddMethod {
            class_replaceMethod(clz, replSel, method_getImplementation(oriMethod!), method_getTypeEncoding(oriMethod!))
        } else {
            method_exchangeImplementations(oriMethod!, repMethod!)
        }
        return true;
    }
    
    /// 实例方法替换
    static func swizzleMethodClass(_ origSel: Selector, replSel: Selector) -> Bool {
        let clz:AnyClass = classForCoder();
        return swizzleMethodInstance(clz, origSel: origSel, replSel: replSel);
    }
    
    /// 类方法替换
    func swizzleMethodInstance(_ origSel: Selector, replSel: Selector) -> Bool {
        let clz:AnyClass = classForCoder;
        return NSObject.swizzleMethodInstance(clz, origSel: origSel, replSel: replSel);
    }

}

@objc public extension NSObject{
    class func initializeMethod() {
        if self == NSObject.self {
            let onceToken = "Method Swizzling_\(NSStringFromClass(classForCoder()))";
            //DispatchQueue函数保证代码只被执行一次，防止又被交换回去导致得不到想要的效果
            DispatchQueue.once(token: onceToken) {
                let oriSel = #selector(self.setValue(_:forUndefinedKey:))
                let repSel = #selector(self.hook_setValue(_:forUndefinedKey:))
                _ = swizzleMethodInstance(NSObject.self, origSel: oriSel, replSel: repSel);
                
                let oriSel0 = #selector(self.value(forUndefinedKey:))
                let repSel0 = #selector(self.hook_value(forUndefinedKey:))
                _ = swizzleMethodInstance(NSObject.self, origSel: oriSel0, replSel: repSel0);
                
                let oriSel1 = #selector(self.setNilValueForKey(_:))
                let repSel1 = #selector(self.hook_setNilValueForKey(_:))
                _ = swizzleMethodInstance(NSObject.self, origSel: oriSel1, replSel: repSel1);
                
                let oriSel2 = #selector(self.setValuesForKeys(_:))
                let repSel2 = #selector(self.hook_setValuesForKeys(_:))
                _ = swizzleMethodInstance(NSObject.self, origSel: oriSel2, replSel: repSel2);
            }
        }
    }
    
    private func hook_setValue(_ value: Any?, forUndefinedKey key: String){
        print("setValue: forUndefinedKey:, 未知键Key: \(key)");
        
    }
    
    private func hook_value(forUndefinedKey key: String) -> Any?{
        print("valueForUndefinedKey:, 未知键: \(key)");
        return nil;
    }
    
    private func hook_setNilValueForKey(_ key: String){
        print("Invoke setNilValueForKey:, 不能给非指针对象(如NSInteger)赋值 nil");
        return;//给一个非指针对象(如NSInteger)赋值 nil, 直接忽略
    }
    
    private func hook_setValuesForKeys(_ keyedValues: [String : Any]) {
        for (key, value) in keyedValues {
//            DDLog(key, value);
            if value is Int || value is CGFloat || value is Double {
                self.setValue("\(value)", forKey: key)
            } else {
                self.setValue(value, forKey: key)
            }
        }
    }
}
