//
//  NSDictionary+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/9/4.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit


public extension Dictionary{
    
    /// ->Data
    var jsonData: Data? {
        return (self as NSDictionary).jsonData;
    }
    
    /// ->NSString
    var jsonString: String {
        return (self as NSDictionary).jsonString;
    }
}

public extension Dictionary where Key == String, Value == String {
    /// 键值翻转
    var reversed: [String : String] {
        var dic: [String : String] = [:]
        for (key, value) in self {
            dic[value] = key
        }
        return dic;
    }
}

@objc public extension NSDictionary{
    /// 键值翻转
    var reversed: [String : String] {
        return (self as! Dictionary).reversed
    }
    
    /// ->Data
    var jsonData: Data? {
        var data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: self, options: []);
        } catch {
            print(error)
        }
        return data;
    }
    
    /// ->NSString
    var jsonString: String {
        guard let jsonData = self.jsonData as Data?,
        let jsonString = String(data: jsonData, encoding: .utf8) as String?
        else { return "" }
        return jsonString
    }
    
}
