//
//  UIFont+Hook.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/7/13.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

@objc public extension UIFont{
    override class func initializeMethod() {
        super.initializeMethod();
        if self == UIFont.self {
            let onceToken = "Method Swizzling_\(NSStringFromClass(classForCoder()))";
            //DispatchQueue函数保证代码只被执行一次，防止又被交换回去导致得不到想要的效果
            DispatchQueue.once(token: onceToken) {
                let oriSel0 = #selector(systemFont(ofSize:))
                let repSel0 = #selector(swz_systemFont(ofSize:))
                
                let _ = swizzleMethodInstance(UIImageView.self, origSel: oriSel0, replSel: repSel0);
                
            }
        }
    }
    
    private class func swz_systemFont(ofSize fontSize: CGFloat) -> UIFont{
        return UIFont(name: UIFont.kPingFangRegular, size: fontSize)!
    }

}

@objc public extension UIFont{
    static let kPingFang           = "PingFang SC";
    static let kPingFangMedium     = "PingFangSC-Medium";
    static let kPingFangSemibold   = "PingFangSC-Semibold";
    static let kPingFangLight      = "PingFangSC-Light";
    static let kPingFangUltralight = "PingFangSC-Ultralight";
    static let kPingFangRegular    = "PingFangSC-Regular";
    static let kPingFangThin       = "PingFangSC-Thin";

}
