//
//  UIApplication+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/24.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension UIApplication{
    
    static var isPortrait: Bool {
        //横竖屏判断
        let orientation = UIApplication.shared.statusBarOrientation
        return orientation.isPortrait
    }
    
    static var appName: String {
        guard let infoDic = Bundle.main.infoDictionary else { return "" }
        if let name = infoDic["CFBundleDisplayName"] {
            return name as! String;
        }
        return infoDic[kCFBundleExecutableKey as String] as! String;
    }
    
    static var appBundleName: String {
        guard let infoDic = Bundle.main.infoDictionary else { return "" }
        return infoDic["CFBundleExecutable"] as! String;
    }
    
    static var appIcon: UIImage {
        guard let infoDic = Bundle.main.infoDictionary as? AnyObject,
            let iconFiles: [Any] = infoDic.value(forKeyPath: "CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles") as? [Any],
            let imgName: String = iconFiles.last as? String,
            let image = UIImage(named: imgName)
            else { return UIImage() }
        return image
    }
    
    static var appVer: String {
        guard let infoDic = Bundle.main.infoDictionary,
            let version = infoDic["CFBundleShortVersionString"] as? String
        else { return "" }
        return version
    }
    
    static var appBuild: String {
        guard let infoDic = Bundle.main.infoDictionary,
            let version = infoDic["CFBundleVersion"] as? String
        else { return "" }
        return version
    }
    
    static var phoneSystemVer: String {
        return UIDevice.current.systemVersion;
    }
    
    static var phoneSystemName: String {
        return UIDevice.current.systemName;
    }
    
    static var phoneName: String {
        return UIDevice.current.name;
    }
    
    static var iphoneType: String {
        return UIApplication.getIphoneType();
    }
    
    /// 获取手机型号
    static func getIphoneType() ->String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let identifier = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":  return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":  return "iPhone 5"
        case "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":  return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":  return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
    
    static var mainWindow: UIWindow {
        get {
            var window = objc_getAssociatedObject(self, RuntimeKeyFromType(self, aSelector: #function)) as? UIWindow;
            if window == nil {
                window = UIWindow(frame: UIScreen.main.bounds)
                objc_setAssociatedObject(self, RuntimeKeyFromType(self, aSelector: #function), window, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            window!.backgroundColor = UIColor.white
            window!.makeKeyAndVisible()
            return window!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromType(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
        
    static var rootController: UIViewController {
        get {
            return UIApplication.mainWindow.rootViewController!;
        }
        set {
            UIApplication.mainWindow.rootViewController = newValue;
        }
    }
    
    static var tabBarController: UITabBarController? {
        get {
            var tabBarVC = objc_getAssociatedObject(self, RuntimeKeyFromType(self, aSelector: #function)) as? UITabBarController;
            if tabBarVC == nil {
                if UIApplication.mainWindow.rootViewController is UITabBarController {
                    tabBarVC = (UIApplication.mainWindow.rootViewController as! UITabBarController);
                }
            }
            return tabBarVC;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromType(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    //MARK: func
    static func setupRootController(_ window: UIWindow = UIApplication.mainWindow, _ controller: AnyObject, _ isAdjust: Bool = true) {
        UIApplication.setupRootController(controller, isAdjust);
    }
    
    static func setupRootController(_ controller: AnyObject, _ isAdjust: Bool = true) {
        var contr = controller;
        if controller is String {
            contr = UICtrFromString(controller as! String);
        }
        
        if !isAdjust {
            UIApplication.rootController = contr as! UIViewController;
            return;
        }
        
        if controller is UINavigationController || controller is UITabBarController {
            UIApplication.rootController = contr as! UIViewController;
        } else {
            UIApplication.rootController = UINavigationController(rootViewController: contr as! UIViewController);
        }
    }
    
    ///默认风格是白色导航栏黑色标题
    static func setupAppearanceDefault(_ isDefault: Bool = true) {
        let barTintColor: UIColor = isDefault ? UIColor.white : UIColor.theme
        setupAppearanceNavigationBar(barTintColor)
        setupAppearanceScrollView()
        setupAppearanceOthers();
    }
    
    /// 配置UIScrollView默认值
    static func setupAppearanceScrollView() {
        UITableView.appearance().separatorStyle = .singleLine;
        UITableView.appearance().separatorInset = .zero;
        UITableView.appearance().rowHeight = 60;
        
        UITableViewCell.appearance().layoutMargins = .zero;
        UITableViewCell.appearance().separatorInset = .zero;
        UITableViewCell.appearance().selectionStyle = .none;
        
        UIScrollView.appearance().keyboardDismissMode = .onDrag;
        
        if #available(iOS 11.0, *) {
            UITableView.appearance().estimatedRowHeight = 0.0;
            UITableView.appearance().estimatedSectionHeaderHeight = 0.0;
            UITableView.appearance().estimatedSectionFooterHeight = 0.0;
            
            UICollectionView.appearance().contentInsetAdjustmentBehavior = .never;
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never;
        }
    }
    
    static func setupAppearanceOthers() {
        UIButton.appearance().isExclusiveTouch = false;

        UITabBar.appearance().tintColor = UIColor.theme;
        UITabBar.appearance().barTintColor = UIColor.white;
        UITabBar.appearance().isTranslucent = false;
        
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray;
        }
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5.0)
        
    }
    
    /// 配置UINavigationBar默认值
    static func setupAppearanceNavigationBar(_ barTintColor: UIColor) {
        let isDefault: Bool = UIColor.white.equalTo(barTintColor);
        let tintColor = isDefault ? UIColor.black : UIColor.white;
        
        UINavigationBar.appearance().tintColor = tintColor;
        UINavigationBar.appearance().barTintColor = barTintColor;
        UINavigationBar.appearance().setBackgroundImage(UIImage(color: barTintColor), for: UIBarPosition.any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage(color: barTintColor);
        
        let attDic = [NSAttributedString.Key.foregroundColor :   tintColor,
//                      NSAttributedString.Key.font    :   UIFont.boldSystemFont(ofSize:18)
                    ];
        UINavigationBar.appearance().titleTextAttributes = attDic;
//
//        let dicNomal = [NSAttributedString.Key.foregroundColor: UIColor.white,
//        ]
//        UIBarButtonItem.appearance().setTitleTextAttributes(dicNomal, for: .normal)
    }
    
//    static func setupAppearanceTabBar() {
        //         设置字体颜色
//        let attDic_N = [NSAttributedString.Key.foregroundColor: UIColor.black];
//        let attDic_H = [NSAttributedString.Key.foregroundColor: UIColor.theme];
//        UITabBarItem.appearance().setTitleTextAttributes(attDic_N, for: .normal);
//        UITabBarItem.appearance().setTitleTextAttributes(attDic_H, for: .selected);
//        // 设置字体偏移
//        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5.0);
        // 设置图标选中时颜色
//        UITabBar.appearance().tintColor = .red;
//    }
    
    @available(iOS 9.0, *)
    static func setupAppearanceSearchbarCancellButton(_ textColor: UIColor = .theme) {
        let shandow: NSShadow = {
            let shadow = NSShadow();
            shadow.shadowColor = UIColor.darkGray;
            shadow.shadowOffset = CGSize(width: 0, height: -1);
            return shadow;
        }();
        
        let dic: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor:  textColor,
                                                  NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 13),
                                                  NSAttributedString.Key.shadow:  shandow,
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(dic, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(dic, for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(dic, for: .selected)

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
    }
    
    /// http/https请求链接
    func isNormalURL(_ url: NSURL) -> Bool {
        guard let scheme = url.scheme else {
            fatalError("url.scheme不能为nil")
        }
        
        let schemes = ["http", "https"]
        return schemes.contains(scheme)
    }
    
    static let kPrefixHttp = "http://"
    
    static let kPrefixTel = "tel://"
        
    /// 打开网络链接
    static func openURLString(_ string: String) {
//        let set = NSCharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted;
//        let str: String = urlStr.addingPercentEncoding(withAllowedCharacters: set)!;
//        let str: String = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        
        guard let url = URL(string: string) as URL? else {
            print("\(#function):链接无法打开!!!\n\(string)");
            return
        }

        if UIApplication.shared.canOpenURL(url) == false {
            print("\(#function):链接无法打开!!!\n\(string)");
            return
        }
        UIApplication.openURL(url);
    }
    
    /// 打开网络链接
    static func openURL(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url as URL);
        }
    }
    
    /// 远程推送deviceToken处理
    static func deviceTokenString(_ deviceToken: NSData) -> String{
        var deviceTokenString = String()
        if #available(iOS 13.0, *) {
            let bytes = [UInt8](deviceToken)
            for item in bytes {
                deviceTokenString += String(format:"%02x", item&0x000000FF)
            }
            
        } else {
            deviceTokenString = deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<> "))
        }
#if DEBUG
        print("deviceToken：\(deviceTokenString)");
#endif
        return deviceTokenString;
    }
    
    /// block内任务后台执行(block为空可填入AppDelegate.m方法 applicationDidEnterBackground中)
    static func didEnterBackground(_ block: (()->Void)? = nil) {
        let application: UIApplication = UIApplication.shared;
        var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);
        //注册一个后台任务，并提供一个在时间耗尽时执行的代码块
        bgTask = application.beginBackgroundTask(expirationHandler: {
            if bgTask != UIBackgroundTaskIdentifier.invalid {
                //当时间耗尽时调用这个代码块
                //如果在这个代码块返回之前没有调用endBackgroundTask
                //应用程序将被终止
                application.endBackgroundTask(bgTask)
                bgTask = UIBackgroundTaskIdentifier.invalid
            }
        });
        
        let backgroundQueue = OperationQueue()
        backgroundQueue.addOperation() {
            //完成一些工作。我们有几分钟的时间来完成它
            //在结束时，必须调用endBackgroundTask
            NSLog("Doing some background work!")
            if block != nil {
                block!();
            }
            application.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskIdentifier.invalid
        }
    }
    /// 配置app图标(传 nil 恢复默认)
    static func setAppIcon(name: String?) {
        UIViewController.initializeMethod()
        //判断是否支持替换图标, false: 不支持
        if #available(iOS 10.3, *) {
            //判断是否支持替换图标, false: 不支持
            guard UIApplication.shared.supportsAlternateIcons else { return }
            
            //如果支持, 替换icon
            UIApplication.shared.setAlternateIconName(name) { (error) in
                //点击弹框的确认按钮后的回调
                if error != nil {
                    print(error ?? "更换icon发生错误")
                }
            }
        }
    }
}
