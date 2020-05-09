//
//  UIApplication+Helper.swift
//  Xcode11Project
//
//  Created by Bin Shang on 2019/12/5.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit
import SwiftExpand

@objc public extension UIApplication{

    var isNotificationsEnabled: Bool {
        get {
            let isEnabled = UserDefaults.standard.value(forKey: #function) as? Bool
            return isEnabled ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
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


