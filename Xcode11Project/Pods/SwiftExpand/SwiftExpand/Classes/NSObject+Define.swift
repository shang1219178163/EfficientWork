//
//  NSObject+Define.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/28.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

// 定义数据类型(其实就是设置别名)
public typealias SwiftClosure = (AnyObject, AnyObject, Int) -> Void

public typealias ObjClosure = ((AnyObject) -> Void)
public typealias ViewClosure = ((UITapGestureRecognizer?, UIView, NSInteger) -> Void)
public typealias ControlClosure = ((UIControl) -> Void)
public typealias RecognizerClosure = ((UIGestureRecognizer) -> Void)

public typealias TextFieldClosure = ((UITextField) -> Void)
public typealias TextViewClosure = ((UITextView) -> Void)

public typealias CellHeightForRowClosure = ((UITableView, IndexPath) -> CGFloat)
public typealias CellForRowClosure = ((UITableView, IndexPath) -> UITableViewCell?)
public typealias DidSelectRowClosure = ((UITableView, IndexPath) -> Void)

public typealias CellForItemClosure = ((UICollectionView, IndexPath) -> UICollectionViewCell?)
public typealias DidSelectItemClosure = ((UICollectionView, IndexPath) -> Void)

public typealias ScrollViewDidScrollClosure = ((UIScrollView) -> Void)


public struct AssociationKey {
    public static var keysDic: [String: UnsafeRawPointer] = [:]
    public static func from(_ key: String) -> UnsafeRawPointer{
        var value = keysDic[key]
        if value == nil {
            value = (key.data(using: .utf8)?.withUnsafeBytes({ (uint8Ptr) -> UnsafeRawPointer in
                return UnsafeRawPointer(uint8Ptr.baseAddress!)
            }))!
            keysDic[key] = value
        }
        return value!
    }
}

public func AddressOf(_ o: UnsafeRawPointer) -> String {
    let addr = Int(bitPattern: o)
    return String(format: "%p", addr)
}

public func AddressOf<T: AnyObject>(_ o: T) -> String {
    let addr = unsafeBitCast(o, to: Int.self)
//    return String(format: "%p", addr)
    return "\(addr)"
}

// MARK: - 关联属性的key

public func RuntimeKeyFromParams(_ obj: NSObject, funcAbount: String!) -> UnsafeRawPointer {
    let unique = "\(AddressOf(obj))," + funcAbount
    let key: UnsafeRawPointer = AssociationKey.from(unique)
    return key;
}

public func RuntimeKeyFromSelector(_ obj: NSObject, aSelector: Selector) -> UnsafeRawPointer {
    let funcAbount = NSStringFromSelector(aSelector);
    let key: UnsafeRawPointer = RuntimeKeyFromParams(obj, funcAbount: funcAbount)
    return key;
}
///类属性/静态变量
public func RuntimeKeyFromType(_ obj: NSObject.Type, aSelector: Selector) -> UnsafeRawPointer {
    let aSelectorName = NSStringFromSelector(aSelector);
    let unique = "\(obj)," + aSelectorName
    let key: UnsafeRawPointer = AssociationKey.from(unique)
    return key;
}

/// 自定义UIEdgeInsets
public func UIEdgeInsetsMake(_ top: CGFloat = 0, _ left: CGFloat = 0, _ bottom: CGFloat = 0, _ right: CGFloat = 0) -> UIEdgeInsets{
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
}

/// 自定义CGRect
public func CGRectMake(_ x: CGFloat = 0, _ y: CGFloat = 0, _ w: CGFloat = 0, _ h: CGFloat = 0) -> CGRect{
    return CGRect(x: x, y: y, width: w, height: h)
}

/// 自定义CGPointMake
public func CGPointMake(_ x: CGFloat = 0, _ y: CGFloat = 0) -> CGPoint {
    return CGPoint(x: x, y: y)
}

/// 自定义GGSizeMake
public func GGSizeMake(_ w: CGFloat = 0, _ h: CGFloat = 0) -> CGSize {
    return CGSize(width: w, height: h)
}

/// 自定义GGSizeMake
public func UIOffsetMake(_ horizontal: CGFloat = 0, _ vertical: CGFloat = 0) -> UIOffset {
    return UIOffset(horizontal: horizontal, vertical: vertical)
}

///返回类名字符串
public func NNStringFromClass(_ cls: Swift.AnyClass) -> String {
    return String(describing: cls);// return "\(type(of: self))";
}

//获取本地创建类
public func NNClassFromString(_ name: String) -> AnyClass? {
    if let cls = NSClassFromString(name) {
//        print("✅_Objc类存在: \(name)")
        return cls;
     }
     
     let swiftClassName = "\(UIApplication.appBundleName).\(name)";
     if let cls = NSClassFromString(swiftClassName) {
//         print("✅_Swift类存在: \(swiftClassName)")
         return cls;
     }
     print("❌_类不存在: \(name)")
    return nil;
}

/// 获取本地 UIViewController 文件
public func UICtrFromString(_ vcName: String) -> UIViewController {
    assert(vcName.hasSuffix("Controller"), "控制器必须以Controller结尾")
    let cls: AnyClass = NNClassFromString(vcName)!;
    // 通过类创建对象， 不能用cls.init(),有的类可能没有init方法
    // 需将cls转换为制定类型
    let vcCls = cls as! UIViewController.Type;
    // 创建对象
    let controller: UIViewController = vcCls.init();
    return controller;
}

public func UINavCtrFromObj(_ obj: AnyObject) -> UINavigationController?{
    if obj is UINavigationController {
        return obj as? UINavigationController;
        
    } else if obj is String {
        return UINavigationController(rootViewController: UICtrFromString(obj as! String));
        
    } else if obj is UIViewController {
        return UINavigationController(rootViewController: obj as! UIViewController);
        
    }
    return nil;
}

///获取UITabBarItem 数组
public func UITabBarItemsFromList(_ list: [[String]]) -> [UITabBarItem] {
    return UITabBar.barItems(list)
}

/// 获取UIViewController/UINavigationController数组
public func UICtlrListFromList(_ list: [[String]], isNavController: Bool = false) -> [UIViewController] {
    return UIViewController.controllers(list, isNavController: isNavController)
}

/// 获取UINavigationController数组
public func UINavListFromList(_ list: [[String]]) -> [UIViewController] {
    return UICtlrListFromList(list, isNavController: true)
}

///获取UITarBarController
public func UITarBarCtrFromList(_ list: [[String]]) -> UITabBarController {
    let tabBarVC: UITabBarController = UITabBarController()
    tabBarVC.viewControllers = UICtlrListFromList(list, isNavController: true)
    return tabBarVC;
}

/// UIImage快捷方法
public func UIImageNamed(_ name: String, in bundle: Bundle = Bundle.main, renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage?{
    let image = UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(renderingMode)
    return image
}

///// UIImage快捷方法
//public func UIImageNamed(_ name: String, renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage?{
//    let image = UIImage(named: name)?.withRenderingMode(renderingMode)
//    return image
//}

/// UIImage 相等判断
public func UIImageEquelToImage(_ image0: UIImage, image1: UIImage) -> Bool{
    return image0.equelToImage(image1)
}
/// 地址字符串(hostname + port)
public func UrlAddress(_ hostname: String, port: String) ->String {
    return NSString.UrlAddress(hostname, port: port);
}

///// 两个Int(+-*/)
//public func resultByOpt(_ num1: Int, _ num2: Int, result: (Int, Int) -> Int) -> Int {
//    return result(num1, num2);
//}

/// 两个数值(+-*/)
public func resultByOpt<T>(_ num1: T, _ num2: T, result: (T, T) -> T) -> T {
    return result(num1, num2);
}
