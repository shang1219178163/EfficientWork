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

}
