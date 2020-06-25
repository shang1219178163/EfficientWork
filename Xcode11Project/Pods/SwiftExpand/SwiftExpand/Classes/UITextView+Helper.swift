
//
//  UITextView+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/1/15.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

@objc public extension UITextView{
    /// [源]UITextView创建
    static func create(_ rect: CGRect = .zero) -> Self {
        let view = self.init(frame: rect);
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.autocapitalizationType = .none;
        view.autocorrectionType = .no;
        view.backgroundColor = .white;
        
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = UIColor.line.cgColor;
        
        view.textAlignment = .left;
        view.font = UIFont.systemFont(ofSize: 15)
        return view
    }
     
    /// 展示性质UITextView创建
    static func createShow(_ rect: CGRect = .zero) -> UITextView {
        let view = UITextView.create(rect);
        view.contentOffset = CGPoint(x: 0, y: 8)
        view.isEditable = false;
        view.dataDetectorTypes = .all;
        return view
    }
    /// 用户协议点击跳转配制方法
    func setupUserAgreements(_ content: String, tapTexts: [String], tapUrls: [String], tapColor: UIColor = UIColor.theme) {
        let attDic = [NSAttributedString.Key.foregroundColor: self.textColor ?? UIColor.gray,
                      NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 16)
        ]
        
        let attString = NSMutableAttributedString(string: content, attributes: attDic as [NSAttributedString.Key : Any])
        for e in tapTexts.enumerated() {
            let nsRange = (attString.string as NSString).range(of: e.element)
            attString.addAttribute(NSAttributedString.Key.link, value: "\(e.offset)_\(tapUrls[e.offset])", range: nsRange)
        }
        
        let linkAttDic = [NSAttributedString.Key.foregroundColor : tapColor,
        ]
        linkTextAttributes = linkAttDic
        attributedText = attString
        isSelectable = true
        isEditable = false
    }
}
