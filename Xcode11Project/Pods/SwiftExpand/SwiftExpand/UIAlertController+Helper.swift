//
//  UIAlertController+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/1/12.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

/// UIAlertController标题富文本key
public let kAlertCtlrTitle = "attributedTitle"
/// UIAlertController信息富文本key
public let kAlertCtlrMessage = "attributedMessage"
/// UIAlertController按钮颜色key
public let kAlertActionColor = "titleTextColor"

@objc public extension UIAlertController{
    /// 创建系统提示框
    static func createAlert(_ title: String?,
                                  placeholders: [String]? = nil,
                                  msg: String,
                                  actionTitles: [String]? = [kTitleCancell, kTitleSure],
                                  handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
       
        placeholders?.forEach { (placeholder: String) in
            alertController.addTextField(configurationHandler: { (textField: UITextField) in
                textField.placeholder = placeholder

            })
        }
        
        actionTitles?.forEach({ (title:String) in
            let style: UIAlertAction.Style = title == kTitleCancell ? .destructive : .default
            alertController.addAction(UIAlertAction(title: title, style: style, handler: { (action: UIAlertAction) in
                if handler != nil {
                    handler!(alertController, action)
                }
            }))
        })
        return alertController
    }
    
    /// 展示提示框
    static func showAlert(_ title: String?,
                                placeholders: [String]? = nil,
                                msg: String,
                                actionTitles: [String]? = [kTitleCancell, kTitleSure],
                                handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let rootVC = UIApplication.shared.delegate?.window??.rootViewController

        let alertController = UIAlertController.createAlert(title, placeholders: placeholders, msg: msg, actionTitles: actionTitles, handler: handler)
        if actionTitles == nil {
            rootVC?.present(alertController, animated: true, completion: {
                DispatchQueue.main.after(TimeInterval(kDurationToast), execute: {
                    alertController.dismiss(animated: true, completion: nil)
                })
            })
        } else {
            rootVC?.present(alertController, animated: true, completion: nil)

        }
        return alertController
    }
    
    /// 创建系统sheetView
    static func createSheet(_ title: String?,
                                  msg: String? = nil,
                                  items: [String]? = nil,
                                  handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        
        items?.forEach({ (title:String) in
            let style: UIAlertAction.Style = title == kTitleCancell ? .cancel : .default
            alertController.addAction(UIAlertAction(title: title, style: style, handler: { (action: UIAlertAction) in
                alertController.dismiss(animated: true, completion: nil)
                if handler != nil {
                    handler!(alertController, action)
                }
            }))
        })
        
        if items?.contains(kTitleCancell) == false || items == nil {
            alertController.addAction(UIAlertAction(title: kTitleCancell, style: .cancel, handler: { (action: UIAlertAction) in
                alertController.dismiss(animated: true, completion: nil)
                if handler != nil {
                    handler!(alertController, action)
                }
            }))
        }
        return alertController
    }
    
    /// 展示提示框
    static func showSheet(_ title: String?,
                                msg: String? = nil,
                                items: [String]? = nil,
                                handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let rootVC = UIApplication.shared.delegate?.window??.rootViewController

        let alertController = UIAlertController.createSheet(title, msg:msg, items: items, handler: handler)
        rootVC?.present(alertController, animated: true, completion: nil)
        return alertController
    }

    /// 设置标题颜色
    func setTitleColor(_ color: UIColor = .theme) {
        guard let title = title else {
            return;
        }
        
        let attrTitle = NSMutableAttributedString(string: title)
        attrTitle.addAttributes([NSAttributedString.Key.foregroundColor: color], range: NSRange(location: 0, length: title.count))
        setValue(attrTitle, forKey: kAlertCtlrTitle)
    }
    
    /// 设置Message文本换行,对齐方式
    func setMessageParaStyle(_ paraStyle: NSMutableParagraphStyle) {
        guard let message = message else {
            return;
        }

        let attrMsg = NSMutableAttributedString(string: message)
        let attDic = [NSAttributedString.Key.paragraphStyle: paraStyle,
                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),]
        attrMsg.addAttributes(attDic, range: NSRange(location: 0, length: message.count))
        setValue(attrMsg, forKey: kAlertCtlrMessage)
    }
    
}
