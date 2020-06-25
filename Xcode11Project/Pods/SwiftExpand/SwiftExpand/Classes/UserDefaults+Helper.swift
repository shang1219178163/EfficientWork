//
//  UserDefaults+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/10/28.
//  Copyright © 2019 BN. All rights reserved.
//

import Foundation

@objc public extension UserDefaults{
    /// UserDefaults 二次封装
    static func setObject(_ object: Any?, forKey key: String) {
        standard.setValue(object, forKey: key)
    }
    /// UserDefaults 二次封装
    static func object(forKey key: String, default defaultProvider: Any) -> Any? {
        return standard.value(forKey: key) ?? defaultProvider
    }
    /// UserDefaults 二次封装
    static func object(forKeyPath keyPath: String, default defaultProvider: Any) -> Any? {
        return standard.value(forKeyPath: keyPath) ?? defaultProvider
    }
    /// UserDefaults 二次封装
    static func synchronize() {
         standard.synchronize()
     }
    ///UserDefaults 保存模型
    static func setArcObject(_ value: Any?, forkey defaultName: String) {
        guard let value = value else { return }
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        standard.setValue(data, forKey: defaultName)
    }
    ///UserDefaults 解包模型
    static func arcObject(forkey defaultName: String) -> Any? {
        guard let value = standard.object(forKey: defaultName) as? Data else { return nil}
        return NSKeyedUnarchiver.unarchiveObject(with: value);
    }
    
}

public extension UserDefaults{
    /// defaultProvider 默认值
    subscript<T>(key: String, default defaultProvider: @autoclosure () -> T) -> T {
        get {
            return value(forKey: key) as? T ?? defaultProvider()
        }
        set {
            setValue(newValue, forKey: key)
        }
    }

    /// 枚举默认支持 RawRepresentable
    subscript<T: RawRepresentable>(key: String) -> T? {
        get {
            if let rawValue = object(forKey: key) as? T.RawValue {
                return T(rawValue: rawValue)
            }
            return nil
        }
        set {
            set(newValue?.rawValue, forKey: key)
        }
    }
}

