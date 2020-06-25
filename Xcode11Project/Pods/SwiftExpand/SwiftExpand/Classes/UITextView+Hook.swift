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
        
        if self != UITextView.self {
            return
        }

        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))";
        DispatchQueue.once(token: onceToken) {
            let oriSel = NSSelectorFromString("deinit")
            let repSel = #selector(self.hook_deinit)
            _ = hookInstanceMethod(of: oriSel, with: repSel);
        }
        
    }
    
    private func hook_deinit() {
        //需要注入的代码写在此处
        NotificationCenter.default.removeObserver(self)
        self.hook_deinit()
    }
    
    public var placeHolderTextView: UITextView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UITextView;
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

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    private func p_textViewDidBeginEditing(_ n: Notification) {
        placeHolderTextView.isHidden = true
    }
    
    private func p_textViewDidEndEditing(_ n: Notification) {
        placeHolderTextView.isHidden = (self.text != "")
    }
    
    
}
