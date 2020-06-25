
//
//  Number+Helper.swift
//  IntelligentOfParking
//
//  Created by Bin Shang on 2018/12/22.
//  Copyright © 2018 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import Foundation

/// ###,##0.00
public let kNumFormat = "¥###,##0.00";
/// 四舍五入
public let kNumIdentify = "四舍五入";
/// 分隔符,
public let kNumIdentifyDecimal = "分隔符,";
/// 百分比
public let kNumIdentifyPercent = "百分比";
/// 货币$
public let kNumIdentifyCurrency = "货币$";
/// 科学计数法 1.234E8
public let kNumIdentifyScientific = "科学计数法 1.234E8";
/// 加号符号
public let kNumIdentifyPlusSign = "加号符号";
/// 减号符号
public let kNumIdentifyMinusSign = "减号符号";
/// 指数符号
public let kNumIdentifyExponentSymbol = "指数符号";
/// 数字转汉字
public let kNumIdentifySpellOut = "数字转汉字";
/// 格式化为货币标准码 输出：USD 367.12
public let kNumIdentifyCurrencyISOCode = "格式化为货币标准码输出";
/// 格式化为货币 输出：367.12 US dollars/367.12 人民币
public let kNumIdentifyCurrencyPlural = "格式化为货币输出";
/// 格式化为货币会计 输出：$367.12
public let kNumIdentifyCurrencyAccounting = "格式化为货币会计输出";

//MARK: -NumberFormatter
@objc public extension NumberFormatter{
    
    static var styleDic: [String: Any] {
        let dic: [String: Any] = [
            kNumIdentify: NumberFormatter.Style.none,
            kNumIdentifyDecimal: NumberFormatter.Style.decimal,
            kNumIdentifyPercent: NumberFormatter.Style.percent,
            kNumIdentifyCurrency: NumberFormatter.Style.currency,
            kNumIdentifyScientific: NumberFormatter.Style.scientific,
            kNumIdentifySpellOut: NumberFormatter.Style.spellOut,
            kNumIdentifyCurrencyISOCode: NumberFormatter.Style.currencyISOCode,
            kNumIdentifyCurrencyPlural: NumberFormatter.Style.currencyPlural,
            kNumIdentifyCurrencyAccounting: NumberFormatter.Style.currencyAccounting,
        ];
        return dic
    }

    /// 根据定义的关键字生成/获取对应的NumberFormatter,避免多次创建
    static func identify(_ identify: String = kNumIdentify) -> NumberFormatter {
        let dic = Thread.current.threadDictionary
        if let formatter = dic.object(forKey: identify) as? NumberFormatter {
            return formatter
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
    static func fractionDigits(obj: CGFloat,
                                     min: Int = 2,
                                     max: Int = 2,
                                     roundingMode: NumberFormatter.RoundingMode = .halfUp, identify: String = kNumIdentify) -> String {
        let fmt = NumberFormatter.identify(identify)
        fmt.minimumFractionDigits = min
        fmt.maximumFractionDigits = max
        fmt.roundingMode = roundingMode
        return fmt.string(for: obj) ?? ""
    }
    
    /// format 格式金钱显示
    static func positive(_ obj: CGFloat, format: String = kNumFormat, defalut: String = "-") -> String {
        let fmt = NumberFormatter.identify(kNumIdentifyDecimal)
        fmt.positiveFormat = format
        return fmt.string(for: obj) ?? defalut
    }
    
    /// 千分位格式金钱显示(10204500 --> 10,204,500.00)
    static func positive(_ obj: CGFloat, prefix: String = "", suffix: String = "", defalut: String = "-") -> String {
        let fmt = NumberFormatter.identify(kNumIdentifyDecimal)
        fmt.positivePrefix = prefix
        fmt.positiveSuffix = suffix

        fmt.usesGroupingSeparator = true //分隔设true
        fmt.groupingSeparator = "," //分隔符
        fmt.groupingSize = 3  //分隔位数
        return fmt.string(for: obj) ?? defalut
    }
    
    /// number为NSNumber/String
    static func localizedString(_ style: NumberFormatter.Style = .none, from number: Any, defalut: String = "-") -> String? {
        if let obj = number as? NSNumber {
            return NumberFormatter.localizedString(from: obj, number: style);
        }

        guard let obj = number as? String else { return defalut }

        let set = CharacterSet(charactersIn: kSetFloat).inverted
        let result = obj.components(separatedBy: set).joined(separator: "")
        if result.count > 0 {
            return NumberFormatter.localizedString(from: NSNumber(value: result.floatValue), number: style);
        }
        return defalut
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
        let result = NumberFormatter.fractionDigits(obj: CGFloat(self.floatValue), min: 2, max: max, roundingMode: .up)
        return result
    }
  
}


