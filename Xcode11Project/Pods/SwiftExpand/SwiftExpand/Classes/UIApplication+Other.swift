//
//  UIApplication+Other.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/4/25.
//

import UIKit
import UserNotifications
import Photos

@objc public extension UIApplication{
    /// 全局token
    static var token: String {
        get {
            return UserDefaults.standard.string(forKey: #function) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// 是否已经登录
    static var isLogin: Bool {
        return UIApplication.token.count > 0;
    }
    
    /// 网络状态是否可用
    static func reachable() -> Bool {
        let data = NSData(contentsOf: URL(string: "https://www.baidu.com/")!)
        return (data != nil)
    }
    /// 消息推送是否可用
    static func hasRightOfPush() -> Bool {
        let notOpen = UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType(rawValue: 0)
        return !notOpen;
    }
    /// 用户相册是否可用
    static func hasRightOfPhotoLibrary() -> Bool {
        var isHasRight = false;
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                isHasRight = true;
          
            default:
                isHasRight = false;
            }
        }
        return isHasRight;
    }
    
    /// 注册APNs远程推送
    static func registerAPNsWithDelegate(_ delegate: Any) {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.delegate = (delegate as! UNUserNotificationCenterDelegate);
            center.requestAuthorization(options: options){ (granted: Bool, error:Error?) in
                if granted {
                    print("success")
                }
            }
            UIApplication.shared.registerForRemoteNotifications()
            //            center.delegate = self
        } else {
            // 请求授权
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            // 需要通过设备UDID, 和app bundle id, 发送请求, 获取deviceToken
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func addLocalUserNoti(trigger: AnyObject,
                          content: UNMutableNotificationContent,
                          identifier: String,
                          notiCategories: AnyObject,
                          repeats: Bool = true,
                          handler: ((UNUserNotificationCenter, UNNotificationRequest, NSError?)->Void)?) {
        
        var notiTrigger: UNNotificationTrigger?
        if let date = trigger as? NSDate {
            var interval = date.timeIntervalSince1970 - NSDate().timeIntervalSince1970;
            interval = interval < 0 ? 1 : interval;
            
            notiTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        } else if let components = trigger as? DateComponents {
            notiTrigger = UNCalendarNotificationTrigger(dateMatching: components as DateComponents, repeats: repeats)
            
        } else if let region = trigger as? CLCircularRegion {
            notiTrigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
            
        }
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notiTrigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error) in
            if error == nil {
                return;
            }
            DDLog("推送已添加成功");
        }
    }
    
    /// app商店链接
    static func appUrlWithID(_ appStoreID: String) -> String {
        let appStoreUrl = "itms-apps://itunes.apple.com/app/id\(appStoreID)?mt=8"
        return appStoreUrl
    }
    
    /// app详情链接
    static func appDetailUrlWithID(_ appStoreID: String) -> String {
        let detailUrl = "http://itunes.apple.com/cn/lookup?id=\(appStoreID)"
        return detailUrl
    }
    
    /// 版本升级
    static func updateVersion(appStoreID: String, isForce: Bool = false) -> Bool {
        var isUpdate = false;
        
//        let path = "http://itunes.apple.com/cn/lookup?id=\(appStoreID)"
        let path =  UIApplication.appDetailUrlWithID(appStoreID)
        let request = URLRequest(url:NSURL(string: path)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 6)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, respone, error) in
            guard let data = data, let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                print("字典不能为空")
                return
            }
            
            guard (dic["resultCount"] as! NSNumber).intValue == 1 else {
                print("resultCount错误")
                return
            }
            
            guard let list = dic["results"] as? NSArray,
                let dicInfo = list[0] as? [String: Any],
                let appStoreVer = dicInfo["version"] as? String
            else {
                print("dicInfo错误")
                return
            }
            
            let releaseNotes = dicInfo["releaseNotes"] ?? "";
            //            print(dicInfo);
            isUpdate = appStoreVer.compare(UIApplication.appVer, options: .numeric, range: nil, locale: nil) == .orderedDescending
            if isUpdate == true {
                DispatchQueue.main.async {
                    let titles = isForce == false ? [kTitleUpdate, kTitleCancell] : [kTitleUpdate];
                    let alertController = UIAlertController.createAlert("新版本 v\(appStoreVer)", msg: "\n\(releaseNotes)", actionTitles: titles, handler: { (controller: UIAlertController, action: UIAlertAction) in
                        if action.title == kTitleUpdate {
                            //去升级
                            _ = UIApplication.openURLString(UIApplication.appUrlWithID(appStoreID))
                        }
                    })
                    
                    //富文本效果
                    let paraStyle = NSMutableParagraphStyle.create(.byCharWrapping, alignment: .left)
                    alertController.setTitleColor(UIColor.theme)
                    alertController.setMessageParaStyle(paraStyle)
//                        alertController.actions.first?.setValue(UIColor.orange, forKey: kAlertActionColor);
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
        
        dataTask.resume()
        return isUpdate;
    }

}
