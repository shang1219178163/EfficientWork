//
//  Date+Helper.swift
//  SwiftTemplet
//
//  Created by dev on 2018/12/11.
//  Copyright © 2018年 BN. All rights reserved.
//
/*
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 */

import UIKit

/// 60s
public let kDateMinute: Double = 60 ;
/// 3600s
public let kDateHour: Double   = 3600 ;
/// 86400
public let kDateDay: Double    = 86400 ;
/// 604800
public let kDateWeek: Double   = 604800 ;
/// 31556926
public let kDateYear: Double   = 31556926 ;


/// yyyy-MM-dd HH:mm:ss(默认)
public let kDateFormat            = "yyyy-MM-dd HH:mm:ss";
/// yyyy-MM
public let kDateFormatMonth       = "yyyy-MM";
/// yyyy-MM-dd
public let kDateFormatDay         = "yyyy-MM-dd";
/// yyyy-MM-dd HH
public let kDateFormatHour        = "yyyy-MM-dd HH";
/// yyyy-MM-dd HH:mm
public let kDateFormatMinute      = "yyyy-MM-dd HH:mm";
/// yyyy-MM-dd HH:mm:ss eee
public let kDateFormatMillisecond = "yyyy-MM-dd HH:mm:ss eee";
/// yyyy-MM-dd 00:00:00
public let kDateFormatBegin       = "yyyy-MM-dd 00:00:00";
/// yyyy-MM-dd 23:59:59
public let kDateFormatEnd         = "yyyy-MM-dd 23:59:59";

/// yyyy-MM-dd HH:mm:00
public let kTimeFormatBegin       = "yyyy-MM-dd HH:mm:00";
/// yyyy-MM-dd HH:mm:59
public let kTimeFormatEnd         = "yyyy-MM-dd HH:mm:59";

/// yyyy年M月
public let kDateFormatMonth_CH    = "yyyy年MM月";
/// yyyy年MM月dd日
public let kDateFormatDay_CH      = "yyyy年MM月dd日";
/// yyyyMMdd
public let kDateFormatTwo         = "yyyyMMdd";


@objc public extension DateFormatter{
    /// 获取DateFormatter(默认格式)
    static func format(_ formatStr: String = kDateFormat) -> DateFormatter {
        let dic = Thread.current.threadDictionary;
        if let formatter = dic.object(forKey: formatStr) as? DateFormatter {
            return formatter
        }
        
        let fmt = DateFormatter();
        fmt.dateFormat = formatStr;
        fmt.locale = .current;
        fmt.locale = Locale(identifier: "zh_CN");
        fmt.timeZone = formatStr.contains("GMT") ? TimeZone(identifier: "GMT") : TimeZone.current;
        dic.setObject(fmt, forKey: formatStr as NSCopying)
        return fmt;
    }
    
    /// Date -> String
    static func stringFromDate(_ date: Date, fmt: String = kDateFormat) -> String {
        let formatter = DateFormatter.format(fmt);
        return formatter.string(from: date);
    }
    
    /// String -> Date
    static func dateFromString(_ dateStr: String, fmt: String = kDateFormat) -> Date {
        let formatter = DateFormatter.format(fmt);
        let result = formatter.date(from: dateStr);
        return result!
    }
    
    /// 时间戳字符串 -> 日期字符串
    static func stringFromInterval(_ interval: String, fmt: String = kDateFormat) -> String {
        let date = Date(timeIntervalSince1970: interval.doubleValue)
        return DateFormatter.stringFromDate(date, fmt: fmt);
    }

    /// 日期字符串 -> 时间戳字符串
    static func intervalFromDateStr(_ dateStr: String, fmt: String = kDateFormat) -> String {
        let date = DateFormatter.dateFromString(dateStr, fmt: fmt)
        return "\(date.timeIntervalSince1970)";
    }
    
    /// 日期字符串和fmt是同种格式
    static func isSameFormat(_ dateStr: String, fmt: String = kDateFormat) -> Bool {
        
        if dateStr.count == fmt.count {
            let str: NSString = dateStr as NSString
            let format: NSString = fmt as NSString

            if str.length >= 17 {
                let char4 = str.substring(with: NSRange(location: 4, length: 1))
                let char7 = str.substring(with: NSRange(location: 7, length: 1))
                let char13 = str.substring(with: NSRange(location: 13, length: 1))
                let char16 = str.substring(with: NSRange(location: 16, length: 1))
              
                let format4 = format.substring(with: NSRange(location: 4, length: 1))
                let format7 = format.substring(with: NSRange(location: 7, length: 1))
                let format13 = format.substring(with: NSRange(location: 13, length: 1))
                let format16 = format.substring(with: NSRange(location: 16, length: 1))
                
                let isSame = (char4 == format4 && char7 == format7 && char13 == format13 && char16 == format16)
                return isSame;
            }
            
            if str.length >= 14 {
                let char4 = str.substring(with: NSRange(location: 4, length: 1))
                let char7 = str.substring(with: NSRange(location: 7, length: 1))
                let char13 = str.substring(with: NSRange(location: 13, length: 1))
                
                let format4 = format.substring(with: NSRange(location: 4, length: 1))
                let format7 = format.substring(with: NSRange(location: 7, length: 1))
                let format13 = format.substring(with: NSRange(location: 13, length: 1))
                
                let isSame = (char4 == format4  && char7 == format7 && char13 == format13)
                return isSame;
            }
           
            if str.length >= 8 {
                let char4 = str.substring(with: NSRange(location: 4, length: 1))
                let char7 = str.substring(with: NSRange(location: 7, length: 1))
               
                let format4 = format.substring(with: NSRange(location: 4, length: 1))
                let format7 = format.substring(with: NSRange(location: 7, length: 1))
                
                let isSame = (char4 == format4  && char7 == format7)
                return isSame;
            } else if str.length >= 5 {
                let char4 = str.substring(with: NSRange(location: 4, length: 1))
                
                let format4 = format.substring(with: NSRange(location: 4, length: 1))
                
                let isSame = (char4 == format4)
                return isSame;
            }
        }
        return false
    }
    
    /// 获取起止时间区间数组,默认往前31天
    static func queryDate(_ day: Int = -30, fmtStart: String = kDateFormatBegin, fmtEnd: String = kDateFormatEnd) -> [String] {
        let endTime = DateFormatter.stringFromDate(Date(), fmt: fmtEnd)
        let date = Date().adding(day)
        let startTime = DateFormatter.stringFromDate(date, fmt: fmtStart)
        return [startTime, endTime];
    }
    
    ///获取指定时间内的所有天数日期
    static func getDateDays(_ startTime: String, endTime: String, fmt: String = kDateFormatDay) -> [String] {
        let calendar = Calendar(identifier: .gregorian)
        
        var startDate = DateFormatter.dateFromString(startTime, fmt: fmt)
        let endDate = DateFormatter.dateFromString(endTime, fmt: fmt)

        var days: [String] = []
        var comps: DateComponents?
        
        var result = startDate.compare(endDate)
        while result != .orderedDescending {
            comps = calendar.dateComponents([.year, .month, .day, .weekday], from: startDate)
            
            let time = DateFormatter.stringFromDate(startDate, fmt: fmt)
            days.append(time)
            
            if comps != nil {
                comps!.day! += 1
                startDate = calendar.date(from: comps!)!
                result = startDate.compare(endDate)
            }
        }
        return days
    }
    ///根据 UIDatePicker.Mode 获取时间字符串简
    static func dateFromPicker(_ datePicker: UIDatePicker, date: Date) -> String {
        var result = DateFormatter.stringFromDate(date)
        switch datePicker.datePickerMode {
        case .time, .countDownTimer:
            result = (result as NSString).substring(with: NSMakeRange(11, 5))

            break;
        case .date:
            result = (result as NSString).substring(with: NSMakeRange(0, 10))
            break;

        default:
            result = (result as NSString).substring(with: NSMakeRange(0, 16))
            break
        }
        return result
    }
}

@objc public extension NSDate{
    
    /// 本地时间(东八区时间)
    static var dateLocale: NSDate {
//        return NSDate().addingTimeInterval(8 * 60 * 60)
        let interval = NSTimeZone.system.secondsFromGMT(for: NSDate() as Date)
        return NSDate().addingTimeInterval(TimeInterval(interval))
    }
    
    /// 年
    var year: Int {
        return NSDate.dateComponents(self).year!
    }
    /// 月
    var month: Int {
        return NSDate.dateComponents(self).month!
    }
    /// 日
    var day: Int {
        return NSDate.dateComponents(self).day!;
    }
    /// 时
    var hour: Int {
        return NSDate.dateComponents(self).hour!;
    }
    /// 分
    var minute: Int {
       return NSDate.dateComponents(self).minute!;
    }
    /// 秒
    var second: Int {
    return NSDate.dateComponents(self).second!;
    }
    
    /// 当月天数
    var countOfDaysInMonth: Int {
        let calendar = NSDate.calendar
        let range = (calendar as NSCalendar?)?.range(of: .day, in: .month, for: self as Date)
        return range!.length
    }
    /// 当月第一天是星期几
    var firstWeekDay: Int {
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        var comp: DateComponents = NSDate.dateComponents(self)
        comp.day = 1
        
        let firstWeekDay = NSDate.weekDay(comp)
        return firstWeekDay
    }
    
    //是否是今天
    var isToday: Bool {
        return NSDate.isSameFrom(self, anotherDate: NSDate(), type: 2)
    }
    //是否是当月
    var isThisMonth: Bool {
        return NSDate.isSameFrom(self, anotherDate: NSDate(), type: 1)
    }
    //是否是今年
    var isThisYear: Bool {
        return NSDate.isSameFrom(self, anotherDate: NSDate(), type: 0)
    }
    
    static var calendar: Calendar = Calendar(identifier: .gregorian)

    /// NSDate转化为日期时间字符串
//    func toString(_ fmt: String = kDateFormat) -> NSString {
//        let dateStr = DateFormatter.stringFromDate(self as Date, fmt: fmt);
//        return dateStr as NSString;
//    }
//    /// 字符串时间戳转NSDate
//    static func fromString(_ dateStr: String, fmt: String = kDateFormat) -> NSDate {
//        let date: NSDate = DateFormatter.dateFromString(dateStr, fmt: fmt) as NSDate;
//        return date;
//    }

    /// 现在时间上添加天:小时:分:秒(负数:之前时间, 正数: 将来时间) -> NSDate
    func adding(_ days: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> NSDate{
        let date: NSDate = addingTimeInterval(TimeInterval(days*24*3600 + hour*3600 + minute*60 + second))
        return date;
    }
    
    /// 现在时间上添加天:小时:分:秒(负数:之前时间, 正数: 将来时间) -> String
    func addingDaysDes(_ days: Int, fmt: String = kDateFormat) -> String{
        let newDate = adding(days);
        return DateFormatter.stringFromDate(newDate as Date, fmt: fmt);
    }
    
    /// 多少时间之前(00:00:00:00/00天00时00分00秒)
    func agoInfo(_ type: Int = 0, length: Int = 8) -> String {
        var interval = Date().timeIntervalSinceNow - self.timeIntervalSinceNow
        
        var info = ""
        switch type {
        case 1:
            
            if interval/kDateDay < 10 {
                info += "0\(Int(interval/kDateDay))" + ":"
            } else {
                info += "\(Int(interval/kDateDay))" + ":"
            }
            interval = interval.truncatingRemainder(dividingBy: kDateDay);
            
            if interval/kDateHour < 10 {
                info += "0\(Int(interval/kDateHour))" + ":"
            } else {
                info += "\(Int(interval/kDateHour))" + ":"
            }
            interval = interval.truncatingRemainder(dividingBy: kDateHour);
            
            if interval/kDateMinute < 10 {
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
            info = "\(Int(interval/kDateDay))" + "天"
            interval = interval.truncatingRemainder(dividingBy: kDateDay);
            
            info += "\(Int(interval/kDateHour))" + "时"
            interval = interval.truncatingRemainder(dividingBy: kDateHour);
            
            info += "\(Int(interval/kDateMinute))" + "分"
            interval = interval.truncatingRemainder(dividingBy: kDateMinute);
            
            info += "\(Int(interval))" + "秒"
        }
        return info.substringFrom(info.count - length);
    }
    
    func hourInfoBetween(_ date: NSDate,_ type: Int = 0) -> Double {
        var diff = self.timeIntervalSinceNow - date.timeIntervalSinceNow
        switch type {
        case 1://分钟
            diff = fabs(diff/60)
            
        case 2://小时
            diff = fabs(diff/3600)
            
        case 3://天
            diff = fabs(diff/86400)
            
        default://秒
            diff = fabs(diff)
        }
        return diff;
    }
    
    func daysInBetween(_ date: NSDate) -> Double {
        return hourInfoBetween(date, 3)
    }
    
    func hoursInBetween(_ date: NSDate) -> Double {
        return hourInfoBetween(date, 2)
    }
    
    func minutesInBetween(_ date: NSDate) -> Double {
        return hourInfoBetween(date, 1)
    }
    
    func secondsInBetween(_ date: NSDate) -> Double {
        return hourInfoBetween(date, 0)
    }
    
    //MARK: - 获取日期各种值
    
    /// 获取默认DateComponents[年月日]
    static func dateComponents(_ aDate: NSDate) -> DateComponents {
        let com = NSDate.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: aDate as Date)
        return com
    }
    
    /// 两个时间差的NSDateComponents
    static func dateFrom(_ aDate: NSDate, anotherDate: NSDate) -> DateComponents {
        let com = NSDate.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: aDate as Date, to: anotherDate as Date)
        return com
    }
    
    ///包含2个日期的年/月/日/时/分/秒数量
    static func numDateFrom(_ aDate: NSDate, anotherDate: NSDate, type: Int = 0) -> Int {
        let comp = NSDate.dateComponents(aDate)
        let comp1 = NSDate.dateComponents(anotherDate)
        
        var number = comp1.year! - comp.year! + 1;
        switch type {
        case 1:
            number = comp1.month! - comp.month! + 1;
            
        case 2:
            number = comp1.day! - comp.day! + 1;
            
        case 3:
            number = comp1.hour! - comp.hour! + 1;
            
        case 4:
            number = comp1.minute! - comp.minute! + 1;
            
        case 5:
            number = comp1.second! - comp.second! + 1;
            
        default:
            break;
        }
        return number
    }
    
    /// 一周的第几天
    static func weekDay(_ comp: DateComponents) ->Int{
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let newDate = NSDate.calendar.date(from: comp)
        let weekDay = NSDate.calendar.component(.weekday, from: newDate!)
        return weekDay
    }
    
    //MARK: 一周的第几天
    func weekDay(_ addDays: Int = 0) ->Int{
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        var comp: DateComponents = NSDate.dateComponents(self)
        comp.day! += addDays

        let newDate = NSDate.calendar.date(from: comp)
        let weekDay = NSDate.calendar.component(.weekday, from: newDate!)
        return weekDay
    }
    
    //MARK: 周几
    func weekDayDes(_ addDays: Int = 0) ->String{
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let dic: [String: String] = ["1": "周日", "2": "星期一", " 3": "星期二",  "4": "星期三", "5": "星期四", "6": "星期五", "7": "星期六"]
        
        let weekDay = "\(self.weekDay(addDays))"
        let result = dic.keys.contains(weekDay) ? dic[weekDay] : "-"
        return result!
    }
    
    /// 两个时间同年0;同月1;同日2;同时3;同分4;同秒5
    static func isSameFrom(_ aDate: NSDate, anotherDate: NSDate, type: Int = 0) -> Bool {
        let comp = NSDate.dateComponents(aDate)
        let comp1 = NSDate.dateComponents(anotherDate)
        
        var isSame = (comp1.year == comp.year);
        switch type {
        case 1:
            isSame = (comp1.year == comp.year && comp1.month == comp.month);
            
        case 2:
            isSame = (comp1.year == comp.year && comp1.month == comp.month && comp1.day == comp.day);
            
        case 3:
            isSame = (comp1.year == comp.year && comp1.month == comp.month && comp1.day == comp.day && comp1.hour == comp.hour);
            
        case 4:
            isSame = (comp1.year == comp.year && comp1.month == comp.month && comp1.day == comp.day && comp1.hour == comp.hour && comp1.minute == comp.minute);
            
        case 5:
            isSame = (comp1.year == comp.year && comp1.month == comp.month && comp1.day == comp.day && comp1.hour == comp.hour && comp1.second == comp.second);
            
        default:
            break;
        }
        return isSame
    }
    
//    func isSameDay2(_ date1:Date, _ date2:Date) -> Bool {
//        let d1 = Calendar.current.dateComponents([.year,.month,.day], from: date1)
//        let d2 = Calendar.current.dateComponents([.year,.month,.day], from: date2)
//        return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day
//    }
//
//    static func isSameDay3(_ date1: Date, _ date2: Date) -> Bool {
//        return Calendar.current.isDate(date1, inSameDayAs: date2)
//    }
}

public extension NSDate{
    /// DateComponents(年月日时分秒)
    static func components(_ year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) ->DateComponents{
        return DateComponents(calendar: NSDate.calendar, timeZone: nil, era: nil, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    }
}

public extension Date{
    /// 本地时间(东八区时间)
    static var dateLocale: Date {
//        return Date().addingTimeInterval(8 * 60 * 60)
        let interval = NSTimeZone.system.secondsFromGMT(for: Date())
        return Date().addingTimeInterval(TimeInterval(interval))
    }
    /// 年
    var year: Int {
       return (self as NSDate).year
    }
    /// 月
    var month: Int {
       return (self as NSDate).month
    }
    /// 日
    var day: Int {
       return (self as NSDate).day;
    }
    /// 时
    var hour: Int {
       return (self as NSDate).hour;
    }
    /// 分
    var minute: Int {
       return (self as NSDate).minute;
    }
    /// 秒
    var second: Int {
       return (self as NSDate).second;
    }
    /// 当月天数
    var countOfDaysInMonth: Int {
        return (self as NSDate).countOfDaysInMonth
    }
    /// 当月第一天是星期几
    var firstWeekDay: Int {
        return (self as NSDate).firstWeekDay
    }
    //是否是今天
    var isToday: Bool {
        return Date.isSameFrom(self, anotherDate: Date(), type: 2)
    }
    //是否是这个月
    var isThisMonth: Bool {
        return Date.isSameFrom(self, anotherDate: Date(), type: 1)
    }
    
    var isThisYear: Bool {
        return Date.isSameFrom(self, anotherDate: Date(), type: 0)
    }
    
//    /// Date转化为日期时间字符串
//    func toString(_ fmt: String = kDateFormat) -> String {
//        return (self as NSDate).toString(fmt) as String;
//    }
//    /// 字符串时间戳转Date
//    static func fromString(_ dateStr: String, fmt: String = kDateFormat) -> Date {
//        return NSDate.fromString(dateStr, fmt: fmt) as Date;
//    }
    /// 现在时间上添加天:小时:分:秒(负数:之前时间, 正数: 将来时间)
    func adding(_ days: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date{
        return (self as NSDate).adding(days, hour: hour, minute: minute, second: second) as Date
    }

    /// 多少天之前
    func addingDays(_ days: Int, fmt: String = kDateFormat) -> String{
        return (self as NSDate).addingDaysDes(days, fmt: fmt);
    }

//    func agoInfo() -> String {
//        return (self as NSDate).agoInfo();
//    }

    func hourInfoBetween(_ date: Date,_ type: Int = 0) -> Double {
        return (self as NSDate).hourInfoBetween(date as NSDate, type);
    }

    func daysInBetween(_ date: Date) -> Double {
        return (self as NSDate).daysInBetween(date as NSDate);
    }

    func hoursInBetween(_ date: Date) -> Double {
        return (self as NSDate).hoursInBetween(date as NSDate);
    }

    func minutesInBetween(_ date: Date) -> Double {
        return (self as NSDate).minutesInBetween(date as NSDate);
    }

    func secondsInBetween(_ date: Date) -> Double {
        return (self as NSDate).secondsInBetween(date as NSDate);
    }

    //MARK: - 获取日期各种值
    /// 获取默认DateComponents[年月日]
    static func dateComponents(_ aDate: Date) -> DateComponents {
        return NSDate.dateComponents(aDate as NSDate);
    }

    /// 两个时间差的NSDateComponents
    static func dateFrom(_ aDate: Date, anotherDate: Date) -> DateComponents {
        return NSDate.dateFrom(aDate as NSDate, anotherDate: anotherDate as NSDate)
    }

    ///包含2个日期的年/月/日/时/分/秒数量
    static func numDateFrom(_ aDate: Date, anotherDate: Date, type: Int = 0) -> Int {
        return NSDate.numDateFrom(aDate as NSDate, anotherDate: anotherDate as NSDate, type: type)
    }

    /// 一周的第几天
    static func weekDay(_ comp: DateComponents) ->Int{
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        return NSDate.weekDay(comp);
    }
    /// - 日期的一些比较
    /// 两个时间同年0;同月1;同日2;同时3;同分4;同秒5
    static func isSameFrom(_ aDate: Date, anotherDate: Date, type: Int = 0) -> Bool {
        return NSDate.isSameFrom(aDate as NSDate, anotherDate: anotherDate as NSDate, type: type)
    }
    
    /// DateComponents(年月日时分秒)
    static func components(_ year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) ->DateComponents{
        return NSDate.components(year, month: month, day: day, hour: hour, minute: minute, second: second);
    }
    
}


