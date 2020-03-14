
//
//  UITableViewCell+Add.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/29.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension UITableViewCell{
    /// [源]自定义 UITableViewCell 获取方法(兼容OC)
    static func dequeueReusableCell(_ tableView: UITableView, identifier: String = String(describing: self), style: UITableViewCell.CellStyle = .default) -> Self {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil {
            cell = self.init(style: style, reuseIdentifier: identifier);
        }

        cell!.selectionStyle = .none;
        cell!.separatorInset = .zero;
        cell!.layoutMargins = .zero;
        return cell as! Self;
    }
    
    /// [OC简洁方法]自定义 UITableViewCell 获取方法
    static func dequeueReusableCell(_ tableView: UITableView) -> Self {
        return dequeueReusableCell(tableView, identifier: String(describing: self), style: .default)
    }
        
    var imgViewLeft: UIImageView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UIImageView;
            if obj == nil {
                obj = UIImageView(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.isUserInteractionEnabled = true;
                obj!.contentMode = .scaleAspectFit;
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var imgViewRight: UIImageView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UIImageView;
            if obj == nil {
                obj = UIImageView(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.isUserInteractionEnabled = true;
                obj!.contentMode = .scaleAspectFit;
                obj!.image = UIImage(named: kIMG_arrowRight);
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var labelLeft: UILabel {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UILabel;
            if obj == nil {
                obj = UILabel(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.font = UIFont.systemFont(ofSize: 15);
                obj!.textAlignment = .left;
                obj!.numberOfLines = 0;
                obj!.lineBreakMode = .byCharWrapping;
                obj!.isUserInteractionEnabled = true;

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
  
    var labelLeftSub: UILabel {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UILabel;
            if obj == nil {
                obj = UILabel(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.font = UIFont.systemFont(ofSize: 15);
                obj!.textAlignment = .left;
                obj!.numberOfLines = 0;
                obj!.lineBreakMode = .byCharWrapping;
                obj!.font = UIFont.systemFont(ofSize: UIFont.labelFontSize - 2.0);
                obj!.isUserInteractionEnabled = true;

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function)!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var labelRight: UILabel {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UILabel;
            if obj == nil {
                obj = UILabel(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.font = UIFont.systemFont(ofSize: 15);
                obj!.textAlignment = .right;
                obj!.numberOfLines = 0;
                obj!.lineBreakMode = .byCharWrapping;
                obj!.isUserInteractionEnabled = true;

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var labelRightSub: UILabel {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UILabel;
            if obj == nil {
                obj = UILabel(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.font = UIFont.systemFont(ofSize: 15);
                obj!.textAlignment = .right;
                obj!.numberOfLines = 0;
                obj!.lineBreakMode = .byCharWrapping;
                obj!.font = UIFont.systemFont(ofSize: UIFont.labelFontSize - 2.0);
                obj!.isUserInteractionEnabled = true;
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function)!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var btn: UIButton {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UIButton;
            if obj == nil {
                obj = UIButton(type: .custom);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.titleLabel?.font = UIFont.systemFont(ofSize: 15);
                obj!.titleLabel?.adjustsFontSizeToFitWidth = true;
                obj!.titleLabel?.minimumScaleFactor = 1.0;
                obj!.isExclusiveTouch = true;
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var textfield: UITextField {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UITextField;
            if obj == nil {
                obj = UITextField(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.font = UIFont.systemFont(ofSize: 15);
                obj!.textAlignment = .left;
                obj!.contentVerticalAlignment = .center;
                obj!.autocapitalizationType = .none;
                obj!.autocorrectionType = .no;
                obj!.clearButtonMode = .whileEditing;
                obj!.backgroundColor = .white;
                obj!.returnKeyType = .done
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var textView: UITextView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UITextView;
            if obj == nil {
                obj = UITextView(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.font = UIFont.systemFont(ofSize: 15);
                obj!.textAlignment = .left;
                obj!.autocapitalizationType = .none;
                obj!.autocorrectionType = .no;
                obj!.backgroundColor = .white;
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}
