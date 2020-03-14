
//
//  UITextView+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/1/15.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

@objc extension UITextView{
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
}
