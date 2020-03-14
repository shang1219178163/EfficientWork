//
//  UserDefaults+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/10/28.
//  Copyright © 2019 BN. All rights reserved.
//

import Foundation

public extension UserDefaults{
    /// UserDefaults 二次封装
    static func setObject(_ object: Any?, forKey key: String) {
        self.standard.setValue(object, forKey: key)
    }
    /// UserDefaults 二次封装
    static func object(forKey key: String) -> Any? {
        self.standard.value(forKey: key)
    }
    /// UserDefaults 二次封装
    static func object(forKeyPath keyPath: String) -> Any? {
        self.standard.value(forKeyPath: keyPath)
    }
    /// UserDefaults 二次封装
    static func synchronize() {
         self.standard.synchronize()
     }
    ///UserDefaults 保存模型
    static func setArcObject(_ value: Any?, forkey defaultName: String) {
        guard let value = value else { return }
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        self.standard.setValue(data, forKey: defaultName)
    }
    ///UserDefaults 解包模型
    static func arcObject(forkey defaultName: String) -> Any? {
        guard let value = self.standard.object(forKey: defaultName) as? Data else { return nil}
        return NSKeyedUnarchiver.unarchiveObject(with: value);
    }
    
}
