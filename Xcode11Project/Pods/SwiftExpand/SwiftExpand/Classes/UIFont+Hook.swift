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
        
        if self != UIFont.self {
            return
        }
        
        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))";
        DispatchQueue.once(token: onceToken) {
            let oriSel = #selector(systemFont(ofSize:))
            let repSel = #selector(swz_systemFont(ofSize:))
            _ = hookInstanceMethod(of: oriSel, with: repSel);
            
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
