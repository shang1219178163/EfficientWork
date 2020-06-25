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
            let style: UIAlertAction.Style = [kTitleCancell, kTitleNo].contains(title) ? .destructive : .default
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
                                handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) {
        
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
    }
    
    /// 创建包含图片不含message的提示框
    static func createAlertImage(_ title: String?,
                                 image: String,
                                 contentMode: UIView.ContentMode = .scaleAspectFit,
                                  count: Int = 10,
                                  actionTitles: [String]? = [kTitleCancell, kTitleSure],
                                  handler: ((UIAlertController, UIAlertAction) -> Void)? = nil) -> UIAlertController {
        assert(UIImage(named: image) != nil)
        
        let msg = String(repeating: "\n", count: count)
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        // 配置图片
        let image = UIImage(named: image)
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        alertController.view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: alertController.view, attribute: .centerX, multiplier: 1, constant: 0))
        alertController.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: alertController.view, attribute: .centerY, multiplier: 1, constant: 15))
        alertController.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 240))
        alertController.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 17*CGFloat(count) - 30))
        // 配置按钮
        actionTitles?.forEach({ (title:String) in
            let style: UIAlertAction.Style = [kTitleCancell, kTitleNo].contains(title) ? .destructive : .default
            alertController.addAction(UIAlertAction(title: title, style: style, handler: { (action: UIAlertAction) in
                if handler != nil {
                    handler!(alertController, action)
                }
            }))
        })
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
    
    /// [便利方法]提示信息
    static func showAlert(_ title: String = "提示", message: String, alignment: NSTextAlignment = .center, actionTitles: [String]? = [kTitleSure], handler: ((UIAlertController, UIAlertAction) -> Void)? = nil){
        DispatchQueue.main.async {
            let alertVC = UIAlertController.createAlert(title, placeholders: nil, msg: message, actionTitles: actionTitles, handler: handler)
            //富文本效果
            let paraStyle = NSMutableParagraphStyle.create(.byCharWrapping, alignment: alignment)
            alertVC.setMessageParaStyle(paraStyle)
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                rootVC.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    /// 创建包含图片不含message的提示框
    static func showAlertImage(_ title: String?,
                                 image: String,
                                 contentMode: UIView.ContentMode = .scaleAspectFit,
                                  count: Int = 10,
                                  actionTitles: [String]? = [kTitleCancell, kTitleSure],
                                  handler: ((UIAlertController, UIAlertAction) -> Void)? = nil){
        DispatchQueue.main.async {
            let alertVC = UIAlertController.createAlertImage(title, image: image, contentMode: contentMode, count: count, actionTitles: actionTitles, handler: handler)
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                rootVC.present(alertVC, animated: true, completion: nil)
            }
        }
    }
}
