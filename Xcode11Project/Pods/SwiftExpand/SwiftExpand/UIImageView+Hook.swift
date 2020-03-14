//
//  UIImageView+Hook.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/1/2.
//

import UIKit

@objc extension UIImageView{
    override public class func initializeMethod() {
        super.initializeMethod();
        if self == UIImageView.self {
            let onceToken = "Method Swizzling_\(NSStringFromClass(classForCoder()))";
            //DispatchQueue函数保证代码只被执行一次，防止又被交换回去导致得不到想要的效果
            DispatchQueue.once(token: onceToken) {
                let oriSel0 = #selector(setter: self.tintColor)
                let repSel0 = #selector(self.hook_tintColor(_:))
                
                _ = swizzleMethodInstance(UIImageView.self, origSel: oriSel0, replSel: repSel0);
                
            }
        }
    }
    
    private func hook_tintColor(_ color: UIColor!) {
        //需要注入的代码写在此处
        self.hook_tintColor(color)
        
//        let obj1:AnyClass = NSClassFromString(kUITabBarButton)!
//        if self.superview?.isKind(of: obj1) == true {
//            DDLog(self.superview as Any,obj1);
//            return
//        }
        
        if self.image != nil {
            if self.image?.renderingMode != UIImage.RenderingMode.alwaysTemplate {
                self.image = self.image!.withRenderingMode( .alwaysTemplate);
                
            }
        }
    }
}
