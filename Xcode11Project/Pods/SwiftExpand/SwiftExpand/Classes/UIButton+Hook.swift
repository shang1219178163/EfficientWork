
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
        
        if self != UIButton.self {
            return
        }
                
        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))";
        DispatchQueue.once(token: onceToken) {
            let oriSel = #selector(setBackgroundImage(_:for:))
            let repSel = #selector(hook_setBackgroundImage(_:for:))
            _ = hookInstanceMethod(of: oriSel, with: repSel);
            
            let oriSel1 = #selector(setImage(_:for:))
            let repSel1 = #selector(hook_setImage(_:for:))
            _ = hookInstanceMethod(of: oriSel1, with: repSel1);
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

