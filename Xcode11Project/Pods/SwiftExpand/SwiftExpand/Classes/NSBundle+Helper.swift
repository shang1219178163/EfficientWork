//
//  Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/11/20.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit


@objc public extension Bundle{
    /// 读取plist文件
    static func infoDictionary(plist: String) -> [String: AnyObject]? {
        guard
            let pList = Bundle.main.path(forResource: plist, ofType: "plist"),
            let dic = NSDictionary(contentsOfFile: pList)
            else { return nil; }
        return dic as? [String : AnyObject]
    }
    /// 国际化语言适配
    static func localizedString(forKey key: String, comment: String = "", userDefaultsKey: String = "AppLanguage") -> String {
        let defaultValue = NSLocalizedString(key, comment: comment)
        guard let name = UserDefaults.standard.object(forKey: userDefaultsKey) as? String else { return defaultValue }
        guard let lprojBundlePath = Bundle.main.path(forResource: name, ofType: "lproj") else { return defaultValue }
        guard let lprojBundle = Bundle(path: lprojBundlePath) else { return defaultValue }
        let value = NSLocalizedString(key, bundle: lprojBundle, comment: comment)
//        let value = bundle!.localizedString(forKey: key, value: "", table: nil)
        return value;
    }
    
}

