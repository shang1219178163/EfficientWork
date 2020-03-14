//
//  UITextView+Hook.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/11/9.
//

import UIKit

@objc extension UITextView{
    
    override public class func initializeMethod() {
        super.initializeMethod();
        
        if self == UIImageView.self {
            let onceToken = "Method Swizzling_\(NSStringFromClass(classForCoder()))";
            //DispatchQueue函数保证代码只被执行一次，防止又被交换回去导致得不到想要的效果
            DispatchQueue.once(token: onceToken) {
                let oriSel0 = NSSelectorFromString("deinit")
                let repSel0 = #selector(self.hook_deinit)
                
                _ = swizzleMethodInstance(UIImageView.self, origSel: oriSel0, replSel: repSel0);
                
            }
        }
    }
    
    private func hook_deinit() {
        //需要注入的代码写在此处
        NotificationCenter.default.removeObserver(self)
        self.hook_deinit()
    }
    
    public var placeHolderTextView: UITextView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UITextView;
            if obj == nil {
                obj = UITextView(frame: bounds);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.autocapitalizationType = .none;
                obj!.autocorrectionType = .no;
                obj!.backgroundColor = .clear;
                obj!.textColor = .gray
                obj!.textAlignment = .left;
                obj!.font = self.font
                self.addSubview(obj!)
                
                NotificationCenter.default.addObserver(self, selector: #selector(p_textViewDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(p_textViewDidEndEditing(_:)), name: UITextView.textDidEndEditingNotification, object: nil)

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    private func p_textViewDidBeginEditing(_ noti: Notification) {
        placeHolderTextView.isHidden = true
    }
    
    private func p_textViewDidEndEditing(_ noti: Notification) {
        placeHolderTextView.isHidden = false

    }
    
    
}
