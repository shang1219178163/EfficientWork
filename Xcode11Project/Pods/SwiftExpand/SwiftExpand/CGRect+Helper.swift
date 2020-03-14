
//
//  CGRect+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/9/7.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

public extension CGRect{
    
    /// 仿OC方法
    static func make(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect{
        return self.init(x: x, y: y, width: w, height: h)
    }
    /// 仿OC方法
    static func make(_ x: Double, _ y: Double, _ w: Double, _ h: Double) -> CGRect{
        return self.init(x: x, y: y, width: w, height: h)
    }
    /// 仿OC方法
    static func make(_ x: Int, _ y: Int, _ w: Int, _ h: Int) -> CGRect{
        return self.init(x: x, y: y, width: w, height: h)
    }
}
