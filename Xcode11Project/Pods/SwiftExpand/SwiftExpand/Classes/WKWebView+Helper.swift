//
//  WKWebView+Helper.swift
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/13.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit
import WebKit

@objc public extension WKWebView{
    /// WKWebViewConfiguration默认配置
    static var confiDefault: WKWebViewConfiguration {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromType(self, aSelector: #function)) as? WKWebViewConfiguration;
            if obj == nil {
                obj = WKWebViewConfiguration()
                obj!.allowsInlineMediaPlayback = true;
                obj!.selectionGranularity = .dynamic;
                obj!.preferences = WKPreferences();
                obj!.preferences.javaScriptCanOpenWindowsAutomatically = false;
                obj!.preferences.javaScriptEnabled = true;
                
                objc_setAssociatedObject(self, RuntimeKeyFromType(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromType(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// JS注入
    func addUserScript(_ source: String) {
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(userScript)
    }

    /// 字体改变
    static func javaScriptFromTextSizeRatio(_ ratio: CGFloat) -> String {
        let result = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(ratio)%'"
        return result
    }
}
