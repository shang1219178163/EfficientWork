

//
//  UITextField+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/9/10.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension UITextField{
    /// [源]UITextField创建
    static func create(_ rect: CGRect = .zero) -> Self {
        let view = self.init(frame: rect);
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.borderStyle = .none;
        view.contentVerticalAlignment = .center;
        view.clearButtonMode = .whileEditing;
        view.autocapitalizationType = .none;
        view.autocorrectionType = .no;
        view.backgroundColor = .white;
        view.returnKeyType = .done
        view.textAlignment = .left;
        view.font = UIFont.systemFont(ofSize: 15)
        return view
    }
    ///  RightView
    func asoryView(_ isRight: Bool, unitName: String!, viewSize: CGSize = CGSize(width: 25, height: 25)) -> UIView! {
        assert(unitName != nil && unitName.isValid == true);
        
        if unitName.contains("img") {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height));
            view.image = UIImage(named: unitName);
            view.contentMode = .scaleAspectFit;
            view.tag = kTAG_IMGVIEW;
            return view;
        }
       
        let size = sizeWithText(unitName, font: UIFont.labelFontSize, width: kScreenWidth);
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: viewSize.height));
        label.tag = kTAG_LABEL;
        label.text = unitName;
        label.font = UIFont.systemFont(ofSize: 15);
        label.textAlignment = .center;
        label.lineBreakMode = .byCharWrapping;
        label.numberOfLines = 0;
        label.backgroundColor = .clear;
        
        if isRight == true {
            self.rightView = label;
            self.rightViewMode = .always;
            
        } else {
            self.leftView = label;
            self.leftViewMode = .always;
        }
        return label;
    }
    
    /// 返回当前文本框字符串(func textField(_ textField: shouldChangeCharactersIn:, replacementString:) -> Bool 中调用)
    func currentString(replacementString string: String) -> String {
        if self.text?.count == 1 {
            return "";
        }
        return string != "" ? self.text! + string : self.text!.substringTo(self.text!.count - 2);
    }
}
