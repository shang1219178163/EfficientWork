
//
//  UIButton+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/9/19.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

@objc extension UIButton{
    override public class func initializeMethod() {
        super.initializeMethod();
        
        if self == UIButton.self {
            let onceToken = "Method Swizzling_\(NSStringFromClass(classForCoder()))";
            //DispatchQueue函数保证代码只被执行一次，防止又被交换回去导致得不到想要的效果
            DispatchQueue.once(token: onceToken) {
                let oriSel0 = #selector(setBackgroundImage(_:for:))
                let repSel0 = #selector(hook_setBackgroundImage(_:for:))
                
                _ = swizzleMethodInstance(UIImageView.self, origSel: oriSel0, replSel: repSel0);
                
                let oriSel1 = #selector(setImage(_:for:))
                let repSel1 = #selector(hook_setImage(_:for:))
                
                _ = swizzleMethodInstance(UIImageView.self, origSel: oriSel1, replSel: repSel1);
            }
        }
    }
    
    private func hook_setBackgroundImage(_ image: UIImage?, for state: UIControl.State){
        //需要注入的代码写在此处
        hook_setBackgroundImage(image, for: state);
        if image != nil {
            adjustsImageWhenHighlighted = false;
        }
    }
    
    private func hook_setImage(_ image: UIImage?, for state: UIControl.State){
        //需要注入的代码写在此处
        hook_setImage(image, for: state);
        if image != nil {
            adjustsImageWhenHighlighted = false;
        }
    }
}

