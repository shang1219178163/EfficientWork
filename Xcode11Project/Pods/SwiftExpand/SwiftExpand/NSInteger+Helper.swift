//
//  Int+Helper.swift
//  SwiftTemplet
//
//  Created by dev on 2018/12/11.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

public extension Int{
    var isEven: Bool     {  return (self % 2 == 0)  }
    var isOdd: Bool      {  return (self % 2 != 0)  }
    /// 大于0
    var isPositive: Bool {  return (self > 0)   }
    /// 小于0
    var isNegative: Bool {  return (self < 0)   }
    /// 转为Double类型
    var toDouble: Double {  return Double(self) }
    /// 转为Float类型
    var toFloat: Float   {  return Float(self)  }
    /// 转为CGFloat类型
    var toCGFloat: CGFloat   {  return CGFloat(self)  }
    /// 转为String类型
    var toString: String { return NSNumber(integerLiteral: self).stringValue; }
    /// 转为NSNumber类型
    var toNumber: NSNumber { return NSNumber(integerLiteral: self); }
    
    var digits: Int {
        if (self == 0) {
            return 1
        }
//        if(Int(fabs(Double(self))) <= LONG_MAX){
        return Int(log10(fabs(Double(self)))) + 1
//        }
    }
}

public extension Double{
    
    /// 转为String类型
    var toString: String { return NSNumber(floatLiteral: self).stringValue; }
    /// 转为NSNumber类型
    var toNSNumber: NSNumber { return NSNumber(floatLiteral: self); }
    
    /// 保留n为小数
    func roundedTo(_ n: Int) -> Double {
        let format = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.multiplier = 2
        format.roundingMode = .up
        format.maximumFractionDigits = n
        format.number(from: format.string(for: self )! )
        
        return (format.number(from: format.string(for: self )! )) as! Double
    }
    
    /// durationInfo
    func durationInfo(_ type: Int = 0, showAll: Bool = true) -> String {
        var interval = self
        
        var info = ""
        switch type {
        case 1:
            
            if Int(interval/kDateDay) < 10 {
                info += "0\(Int(interval/kDateDay))" + ":"
            } else {
                info += "\(Int(interval/kDateDay))" + ":"
            }
            interval = interval.truncatingRemainder(dividingBy: kDateDay);
            
            if Int(interval/kDateHour) < 10 {
                info += "0\(Int(interval/kDateHour))" + ":"
            } else {
                info += "\(Int(interval/kDateHour))" + ":"
            }
            interval = interval.truncatingRemainder(dividingBy: kDateHour);
            
            if Int(interval/kDateMinute) < 10 {
                info += "0\(Int(interval/kDateMinute))" + ":"
            } else {
                info += "\(Int(interval/kDateMinute))" + ":"
            }
            interval = interval.truncatingRemainder(dividingBy: kDateMinute);
            
            if interval < 10 {
                info += "0\(Int(interval))"
            } else {
                info += "\(Int(interval))"
            }
            
        default:
            
            if showAll == true {
                info = "\(Int(interval/kDateDay))" + "天"
                interval = interval.truncatingRemainder(dividingBy: kDateDay);
                
                info += "\(Int(interval/kDateHour))" + "时"
                interval = interval.truncatingRemainder(dividingBy: kDateHour);
                
                info += "\(Int(interval/kDateMinute))" + "分"
                interval = interval.truncatingRemainder(dividingBy: kDateMinute);
                
                info += "\(Int(interval))" + "秒"
            } else {
                
                if Int(interval/kDateDay) > 0 {
                    info = "\(Int(interval/kDateDay))" + "天"
                }
                interval = interval.truncatingRemainder(dividingBy: kDateDay);
                
                if Int(interval/kDateHour) > 0 {
                    info += "\(Int(interval/kDateHour))" + "时"
                }
                interval = interval.truncatingRemainder(dividingBy: kDateHour);
                
                if Int(interval/kDateMinute) > 0 {
                    info += "\(Int(interval/kDateMinute))" + "分"
                }
                interval = interval.truncatingRemainder(dividingBy: kDateMinute);
                info += "\(Int(interval))" + "秒"
            }
        }
        return info;
    }
}



