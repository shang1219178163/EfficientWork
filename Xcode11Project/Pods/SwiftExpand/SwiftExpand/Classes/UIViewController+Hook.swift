//
//  UIViewController+Hook.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/12/13.
//  Copyright © 2018 BN. All rights reserved.
//

import UIKit

@objc extension UIViewController{
    
    override public class func initializeMethod() {
        super.initializeMethod();
        
        if self == UIViewController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))";
            DispatchQueue.once(token: onceToken) {
                let oriSel = #selector(viewDidLoad)
                let repSel = #selector(hook_viewDidLoad)
                _ = hookInstanceMethod(of: oriSel, with: repSel);
                                
                let oriSel1 = #selector(viewWillAppear(_:))
                let repSel1 = #selector(hook_viewWillAppear(animated:))
                _ = hookInstanceMethod(of: oriSel1, with: repSel1);
                
                let oriSel2 = #selector(viewWillDisappear(_:))
                let repSel2 = #selector(hook_viewWillDisappear(animated:))
                _ = hookInstanceMethod(of: oriSel2, with: repSel2);
                
                let oriSelPresent = #selector(present(_:animated:completion:))
                let repSelPresent = #selector(hook_present(_:animated:completion:))
                _ = hookInstanceMethod(of: oriSelPresent, with: repSelPresent);
                
            }
        } else if self == UINavigationController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))";
            DispatchQueue.once(token: onceToken) {
                let oriSel = #selector(UINavigationController.pushViewController(_:animated:));
                let repSel = #selector(UINavigationController.hook_pushViewController(_:animated:));
                _ = hookInstanceMethod(of:oriSel , with: repSel);
            }
        }
    }
    
    private func hook_viewDidLoad(animated: Bool) {
//        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        edgesForExtendedLayout = [];
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        }
        hook_viewDidLoad(animated: animated)
    }
    
    private func hook_viewWillAppear(animated: Bool) {
        //需要注入的代码写在此处
        hook_viewWillAppear(animated: animated)
//        self.eventGather(isBegin: true);
    }
    
    private func hook_viewWillDisappear(animated: Bool) {
        //需要注入的代码写在此处
        hook_viewWillDisappear(animated: animated)
//        self.eventGather(isBegin: false);
    }
    
    private func hook_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.presentationController == nil {
            viewControllerToPresent.presentationController?.presentedViewController.dismiss(animated: false, completion: nil)
            DDLog("viewControllerToPresent.presentationController 不能为 nil")
            return
        }
        //判断是否是alert弹窗
        if viewControllerToPresent.isKind(of: UIAlertController.self) {
            #if DEBUG
                print("title: \(String(describing: (viewControllerToPresent as? UIAlertController)?.title))")
                print("message: \(String(describing: (viewControllerToPresent as? UIAlertController)?.message))")
            #endif
            // 换图标时的提示框的title和message都是nil，由此可特殊处理
            let alertController = viewControllerToPresent as? UIAlertController
            if alertController?.title == nil && alertController?.message == nil {
                //是更换icon的提示
                changeAppIconAction()
                return
            } else {
                //其他的弹框提示正常处理
                hook_present(viewControllerToPresent, animated: flag, completion: completion)
            }
        } else {
            hook_present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    // MARK: -funtions
    private func eventGather(isBegin: Bool = true) {
        let className = NSStringFromClass(classForCoder);
        //设置不允许发送数据的Controller
        let filters = ["UINavigationController", "UITabBarController", "UICompatibilityInputViewController",
                       "UIInputWindowController", "UIAlertController"];
        if filters.contains(className) {
            return ;
        }
        
        if isBegin == true {
            DDLog("\(NSStringFromClass(classForCoder))--Appear")
        } else {
            DDLog("\(NSStringFromClass(classForCoder))--Disappear")
        }
    }
    
    private func changeAppIconAction(){
        print("替换成功")
    }

}
