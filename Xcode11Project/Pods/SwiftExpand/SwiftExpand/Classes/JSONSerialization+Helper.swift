//
//  JSONSerialization+Helper.swift
//  CloudCustomerService
//
//  Created by Bin Shang on 2019/12/2.
//  Copyright © 2019 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

@objc public extension JSONSerialization{

    
    /// NSObject -> NSData
    static func dataFromObj(_ obj: AnyObject) -> Data? {
        var data: Data?

        switch obj {
        case is Data:
            data = (obj as! Data);

        case is NSString:
            data = (obj as! String).data(using: .utf8);

        case is UIImage:
            data = (obj as! UIImage).jpegData(compressionQuality: 1.0);

        case is NSDictionary, is NSArray:
            do {
                data = try JSONSerialization.data(withJSONObject: obj, options: []);
            } catch {
                print(error)
            }

        default:
            break;
        }
        return data;
    }
    
    /// data -> NSObject
    static func jsonObjectFromData(_ data: Data, options opt: JSONSerialization.ReadingOptions = []) -> Any? {
        return data.objValue
    }
    
    /// NSString -> NSObject/NSDiction/NSArray
    static func jsonObjectFromString(_ string: String, options opt: JSONSerialization.ReadingOptions = []) -> Any? {
        guard let data = string.data(using: .utf8) else { return nil}
        return JSONSerialization.jsonObjectFromData(data);
    }

    /// NSObject -> NSString
    static func jsonStringFromObj(_ obj: AnyObject) -> String {
        guard let data = JSONSerialization.dataFromObj(obj) as Data?,
        let jsonString = String(data: data as Data, encoding: .utf8) as String?
        else { return "" }
        return jsonString
    }

    /// 本地json文件(.geojson) -> NSString
    static func ObjFromGeojson(_ name: String) -> Any? {
        assert(name.contains(".geojson") == true);
         
        let array: Array = name.components(separatedBy: ".");
        guard let path = Bundle.main.path(forResource: array.first, ofType: array.last),
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
        let obj = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        else { return nil}
        return obj
     }
    
}
