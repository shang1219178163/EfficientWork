

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
    
    /// 设置 leftView 图标
    func setupLeftView(image: UIImage?, viewMode: UITextField.ViewMode = .always) {
        if image == nil {
            return
        }
        if leftView != nil {
            leftViewMode = viewMode
            return
        }
     
        leftViewMode = viewMode; //此处用来设置leftview显示时机
        leftView = {
            let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
            
            let imgView = UIImageView(frame:CGRect(x: 0, y: 0, width: 15, height: 15));
            imgView.image = image
            imgView.contentMode = UIView.ContentMode.scaleAspectFit;
            imgView.center = view.center;
            view.addSubview(imgView);
          
            return view;
        }()
    }
    
    ///leftView/rightView
    func asoryView(_ isRight: Bool, type: UIResponder.Type, unit: String, viewSize: CGSize = CGSize(width: 25, height: 25), viewMode: UITextField.ViewMode = .always) -> UIView {
        switch type {
        case is UILabel.Type:
            return asoryView(isRight, text: unit, viewSize: viewSize, viewMode: viewMode)

        case is UIImageView.Type:
            if let image = UIImage(named: unit) {
               return asoryView(isRight, image: image, viewSize: viewSize, viewMode: viewMode)
            }
            
        default:
            break;
        }
        return asoryView(isRight, obj: unit, viewSize: viewSize, viewMode: viewMode)
    }
    ///leftView/rightView -> UILabel
    func asoryView(_ isRight: Bool, text: String, viewSize: CGSize = CGSize(width: 25, height: 25), viewMode: UITextField.ViewMode = .always) -> UILabel {
        isRight ? (self.rightViewMode = viewMode) : (self.leftViewMode = viewMode)
        
        let size = sizeWithText(text, font: 15, width: kScreenWidth);
        let frame = CGRect(x: 0, y: 0, width: size.width + 10, height: viewSize.height)
        
        if let sender = (isRight ? self.rightView : self.leftView) as? UILabel {
            sender.frame = frame
            sender.text = text;
            return sender;
        }
        
        let label: UILabel = {
            let label = UILabel(frame: .zero)
            label.tag = kTAG_LABEL;
            label.textColor = .gray;
            label.font = UIFont.systemFont(ofSize: 15);
            label.textAlignment = .center;
            label.lineBreakMode = .byCharWrapping;
            label.numberOfLines = 0;
            label.backgroundColor = .clear;
            return label
        }()
        label.frame = frame
        label.text = text
        
        isRight ? (self.rightView = label) : (self.leftView = label)
        return label
    }

    ///leftView/rightView -> UIImageView
    func asoryView(_ isRight: Bool, image: UIImage, viewSize: CGSize = CGSize(width: 25, height: 35), viewMode: UITextField.ViewMode = .always) -> UIImageView {
        isRight ? (self.rightViewMode = viewMode) : (self.leftViewMode = viewMode)
        
        let frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        
        if let sender = (isRight ? self.rightView : self.leftView) as? UIImageView {
            sender.frame = frame
            sender.image = image
            return sender;
        }
        
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: .zero)
            imageView.contentMode = .center;
            imageView.tag = kTAG_IMGVIEW;
            return imageView
        }()
        imageView.frame = frame
        imageView.image = image

        isRight ? (self.rightView = imageView) : (self.leftView = imageView)
        return imageView
    }
    
    ///leftView/rightView -> UIButton
    func asoryView(_ isRight: Bool, obj: String, viewSize: CGSize = CGSize(width: 30, height: 35), viewMode: UITextField.ViewMode = .always) -> UIButton {
        isRight ? (self.rightViewMode = viewMode) : (self.leftViewMode = viewMode)

        let frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
                
        if let sender = (isRight ? self.rightView : self.leftView) as? UIButton {
            if let image = UIImage(named: obj) {
                sender.setImage(image, for: .normal)
                sender.frame = frame
            } else {
                sender.setTitle(obj, for: .normal)
                let size = sender.sizeThatFits(.zero)
                sender.frame = CGRect(x: 0, y: 0, width: size.width+5, height: size.height)
            }
            return sender;
        }
        
        let sender: UIButton = {
            let sender = UIButton(type: .custom)
            sender.setTitleColor(.gray, for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            sender.contentMode = .center;
            sender.tag = kTAG_BTN;
            return sender
        }()
        
        if let image = UIImage(named: obj) {
            sender.setImage(image, for: .normal)
            sender.frame = frame

        } else {
            sender.setTitle(obj, for: .normal)
            let size = sender.sizeThatFits(.zero)
            sender.frame = CGRect(x: 0, y: 0, width: size.width+5, height: size.height)
        }
        isRight ? (self.rightView = sender) : (self.leftView = sender)
        return sender
    }
    
    /// 返回当前文本框字符串(func textField(_ textField: shouldChangeCharactersIn:, replacementString:) -> Bool 中调用)
    func currentString(replacementString string: String) -> String {
        if self.text?.count == 1 {
            return "";
        }
        return string != "" ? self.text! + string : self.text!.substringTo(self.text!.count - 2);
    }
    
}
