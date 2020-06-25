
//
//  CGRect+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/9/7.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

public extension CGRect{
    ///中心点
    var center: CGPoint {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return CGPoint(x: centerX, y: centerY)
        }
        set{
            //`newValue`便是所赋新值的点,系统的默认值
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
    
    /// 便利方法
    init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
    /// 仿OC方法
    static func make(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect{
        return self.init(x: x, y: y, width: w, height: h)
    }

}

public extension UIEdgeInsets{
    /// 便利方法
    init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    /// 仿OC方法
    static func make(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> Self{
        return Self(top: top, left: left, bottom: bottom, right: right)
    }
    
}

public extension CGPoint{
    /// 便利方法
    init(_ x: CGFloat = 0, _ y: CGFloat = 0) {
        self.init(x: x, y: y)
    }
    
    /// 仿OC方法
    static func make(_ x: CGFloat = 0, _ y: CGFloat = 0) -> Self{
        return Self(x: x, y: y)
    }

}

public extension CGSize{
    /// 便利方法
    init(_ w: CGFloat = 0, _ h: CGFloat = 0) {
        self.init(width: w, height: h)
    }
    
    /// 仿OC方法
    static func make(_ w: CGFloat = 0, _ h: CGFloat = 0) -> Self{
        return Self(width: w, height: h)
    }

}

public extension UIOffset{
    /// 便利方法
    init(_ horizontal: CGFloat = 0, _ vertical: CGFloat = 0) {
        self.init(horizontal: horizontal, vertical: vertical)
    }
    
    /// 仿OC方法
    static func make(_ horizontal: CGFloat = 0, _ vertical: CGFloat = 0) -> Self{
        return Self(horizontal: horizontal, vertical: vertical)
    }

}
