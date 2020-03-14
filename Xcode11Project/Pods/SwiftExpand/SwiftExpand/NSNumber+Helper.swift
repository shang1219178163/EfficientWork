
//
//  Number+Helper.swift
//  IntelligentOfParking
//
//  Created by Bin Shang on 2018/12/22.
//  Copyright © 2018 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import Foundation

/// #,##0.00
public let kNumFormat = "#,##0.00";
/// 四舍五入
public let kNumIdentify = "四舍五入";
/// 分隔符,
public let kNumIdentify_decimal = "分隔符,";
/// 百分比
public let kNumIdentify_percent = "百分比";
/// 货币$
public let kNumIdentify_currency = "货币$";
/// 科学计数法 1.234E8
public let kNumIdentify_scientific = "科学计数法 1.234E8";
/// 加号符号
public let kNumIdentify_plusSign = "加号符号";
/// 减号符号
public let kNumIdentify_minusSign = "减号符号";
/// 指数符号
public let kNumIdentify_exponentSymbol = "指数符号";

//MARK: -NumberFormatter
@objc public extension NumberFormatter{
    
    static var styleDic: [String: Any] {
        get{
            let dic: [String: Any] = [
                kNumIdentify: NumberFormatter.Style.none,
                kNumIdentify_decimal: NumberFormatter.Style.decimal,
                kNumIdentify_percent: NumberFormatter.Style.percent,
                kNumIdentify_currency: NumberFormatter.Style.currency,
                kNumIdentify_scientific: NumberFormatter.Style.scientific,
            ];
            return dic
        }
    }

    /// 根据定义的关键字生成/获取对应的NumberFormatter,避免多次创建
    static func identify(_ identify: String = kNumIdentify) -> NumberFormatter {
        let dic = Thread.current.threadDictionary;
        if dic.object(forKey: identify) != nil {
            return dic.object(forKey: identify) as! NumberFormatter;
        }
        
        let fmt = NumberFormatter();
        fmt.locale = .current;
        fmt.minimumIntegerDigits = 1
        fmt.minimumFractionDigits = 2
        fmt.maximumFractionDigits = 2
        fmt.roundingMode = .up
        fmt.numberStyle = .none
        if styleDic.keys.contains(identify) {
            fmt.numberStyle = styleDic[identify] as! NumberFormatter.Style
        }
        
        dic.setObject(fmt, forKey: identify as NSCopying)
        return fmt;
    }

    /// 保留小数,默认四舍五入
    static func fractionDigits(obj: Any?,
                                     min: Int = 2,
                                     max: Int = 2, 
                                     roundingMode: NumberFormatter.RoundingMode = .up) -> String {
        let formatter = NumberFormatter.identify() ;
        formatter.minimumFractionDigits = min
        formatter.maximumFractionDigits = max
        formatter.roundingMode = roundingMode
        return formatter.string(for: obj) ?? ""
    }
    
    static func positiveFormat(_ format: String = kNumFormat) -> NumberFormatter {
        let fmt = NumberFormatter.identify();
        fmt.positiveFormat = format;
        return fmt;
    }
    
    /// number为NSNumber/String
    static func numStyle(_ numberStyle: NumberFormatter.Style = .none, number: Any) -> String? {
        if let obj = number as? NSNumber {
            return NumberFormatter.localizedString(from: obj, number: numberStyle);
        }
        
        if let obj = number as? String {
            let set = CharacterSet(charactersIn: kSetFloat).inverted
            let result = obj.components(separatedBy: set).joined(separator: "")
            if obj == result {
                return NumberFormatter.localizedString(from: NSNumber(value: obj.floatValue), number: numberStyle);
                
            }
        }
        return ""
    }
   
}

//MARK: -Number
@objc public extension NSNumber{
    
    var decNumer: NSDecimalNumber {
        get{
            return NSDecimalNumber(decimal: self.decimalValue)
        }
    }
    
    /// 获取对应的字符串
    func to_string(_ max: Int = 2) -> String{
        let result = NumberFormatter.fractionDigits(obj: self, min: 2, max: max, roundingMode: .up)
        return result
    }
  
}


