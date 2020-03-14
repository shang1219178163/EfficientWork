//
//  UIViewController+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/5/16.
//  Copyright © 2018年 BN. All rights reserved.
//

import Foundation
import UIKit

@objc extension UIViewController{
    
    public var controllerName: String {
        var className: String = NNStringFromClass(self.classForCoder);
        if className.contains("Controller") {
            var range = className.range(of: "Controller");
            if className.contains("ViewController") {
                range = className.range(of: "ViewController");
                
            }
            className = String(className[..<range!.lowerBound]);
        }
        return className;
    }
    
    /// 是否正在展示
    public var isCurrentVC: Bool {
        return isViewLoaded == true && (view!.window != nil)
    }
    
    /// [源]创建UISearchController(设置IQKeyboardManager.shared.enable = false;//避免searchbar下移)
    public func createSearchVC(_ resultsController: UIViewController) -> UISearchController {
        definesPresentationContext = true;
        
        let searchVC = UISearchController(searchResultsController: resultsController)
        if resultsController.conforms(to: UISearchResultsUpdating.self) {
            searchVC.searchResultsUpdater = resultsController as? UISearchResultsUpdating;
        }
        
        searchVC.dimsBackgroundDuringPresentation = true;
//        searchVC.hidesNavigationBarDuringPresentation = true;
        if #available(iOS 9.1, *) {
            searchVC.obscuresBackgroundDuringPresentation = true;
        }
        
        searchVC.searchBar.barStyle = .default;
//        searchVC.searchBar.barTintColor = UIColor.theme;
        
        searchVC.searchBar.isTranslucent = false;
//        searchVC.searchBar.setValue("取消", forKey: "_cancelButtonText")
        searchVC.searchBar.placeholder = "搜索";
        
//        searchVC.searchBar.delegate = self;
//        searchVC.delegate = self;
        return searchVC;
    }
    
    /// 重置布局
    public func setupExtendedLayout() {
        edgesForExtendedLayout = [];
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never;
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
    }
    
    private func p_handleActionItem(_ sender: UIBarButtonItem) {
        let block = objc_getAssociatedObject(self, sender.runtimeKey) as? ObjClosure;
        if block != nil {
            block!(sender);
        }
    }
    
    public func createBarItem(_ systemItem: UIBarButtonItem.SystemItem, isLeft: Bool = false, action: @escaping (ObjClosure)) {
        let funcAbount = NSStringFromSelector(#function) + ",\(systemItem)" + ",\(isLeft)"
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        let item:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(p_handleActionItem(_:)));
        item.systemType = systemItem;
        if isLeft == true {
            navigationItem.leftBarButtonItem = item;
        } else {
            navigationItem.rightBarButtonItem = item;
        }
        item.runtimeKey = runtimeKey
        objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC);

    }
    
    /// 创建导航栏按钮(UIButton)
    public func createBtnBarItem(_ title: String?, image: String? = nil, isLeft: Bool = false, isHidden: Bool = false, action: (ControlClosure)? = nil) -> UIButton {
        var size = CGSize(width: 32, height: 32)
        if image != nil && UIImage(named:image!) != nil {
            size = CGSize(width: 40, height: 40)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        let btn: UIButton = UIButton.create(rect, title: title, imgName: image, type: 3)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.tag = isLeft == true ? kTAG_BackItem : kTAG_RightItem;
        btn.isHidden = isHidden;
        btn.sizeToFit();
        
        if image != nil && UIImage(named:image!) != nil {
            btn.setImage(UIImage(named:image!), for: .normal);
        } else {
            if title!.isEmpty == false{
                btn.setTitle(title, for: .normal);
                if title!.count == 4{
                    btn.titleLabel?.adjustsFontSizeToFitWidth = true;
                    btn.titleLabel?.minimumScaleFactor = 1;
                }
            }
        }
        
        if action != nil {
            btn.addActionHandler(action!, for: .touchUpInside)
        }
        let item:UIBarButtonItem = UIBarButtonItem(customView: btn);
        if isLeft == true {
            navigationItem.leftBarButtonItem = item;
        } else {
            navigationItem.rightBarButtonItem = item;
        }
        return btn;
    }
    
    /// 创建导航栏按钮(标题或者图片名称)
    public func createBtnBarItem(_ obj: String, isLeft: Bool = false, action: @escaping (ViewClosure)) -> UIView {
        var item: UIView? = nil;
        if UIImage(named:obj) != nil{
            item = UIImageView.create(CGRectMake(0, 0, 25, 25), imgName: obj)

        } else {
            item = UILabel.create(CGRectMake(0, 0, 72, 20), type: 1)
            (item as! UILabel).text = obj;
            (item as! UILabel).textAlignment = .center;
            (item as! UILabel).textColor = UINavigationBar.appearance().tintColor;
        }
        item!.tag = isLeft ? kTAG_BackItem : kTAG_RightItem;
        
        let containView = UIView(frame: CGRectMake(0, 0, 44, 44))
        item!.center = containView.center;
        containView.addSubview(item!)
        
        _ = containView.addGestureTap { (reco) in
            if containView.isHidden == true {
                return
            }
            action((reco as! UITapGestureRecognizer), (reco.view!.subviews.first)!, (reco.view?.subviews.first!.tag)!)
        }

        let barItem = UIBarButtonItem(customView: containView)
        if isLeft == true {
            navigationItem.leftBarButtonItem = barItem;
        } else {
            navigationItem.rightBarButtonItem = barItem;
        }
        return containView;
    }

    public func goController(_ name: String!, obj: AnyObject? = nil, objOne: AnyObject? = nil) {
        assert(UICtrFromString(name).isKind(of: UIViewController.classForCoder()))
        let controller = UICtrFromString(name)
        controller.obj = obj
        controller.objOne = objOne
        navigationController?.pushViewController(controller, animated: true);
    }
    
    public func addControllerName(_ controllerName: String) {
        let controller = UICtrFromString(controllerName)
        assert(controller.isKind(of: UIViewController.classForCoder()))
        addControllerVC(controller)
    }
    
    /// 添加子控制器(对应方法 removeControllerVC)
    public func addControllerVC(_ controller: UIViewController) {
        assert(controller.isKind(of: UIViewController.classForCoder()))
        
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.frame = self.view.bounds;
        controller.didMove(toParent: self)
    }
    
    /// 移除添加的子控制器(对应方法 addControllerVC)
    public func removeControllerVC(_ controller: UIViewController) {
        assert(controller.isKind(of: UIViewController.classForCoder()))
        
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent();
    }
    
    /// 显示controller(手动调用viewWillAppear和viewDidAppear,viewWillDisappear)
    public func transitionTo(VC: UIViewController) {
        beginAppearanceTransition(false, animated: true)  //调用self的 viewWillDisappear:
        VC.beginAppearanceTransition(true, animated: true)  //调用VC的 viewWillAppear:
        endAppearanceTransition(); //调用self的viewDidDisappear:
        VC.endAppearanceTransition(); //调用VC的viewDidAppear:
        /*
         isAppearing 设置为 true : 触发 viewWillAppear:;
         isAppearing 设置为 false : 触发 viewWillDisappear:;
         endAppearanceTransition方法会基于我们传入的isAppearing来调用viewDidAppear:以及viewDidDisappear:方法
         */
    }
    /// 手动调用 viewWillAppear,viewDidDisappear 或 viewWillDisappear,viewDidDisappear
    public func beginAppearance(_ isAppearing: Bool, animated: Bool){
        beginAppearanceTransition(isAppearing, animated: animated);
        endAppearanceTransition();
    }
    
    /// 导航栏返回按钮图片定制
    public func createBackItem(_ image: UIImage) {
//        let btn = UIButton(type: .custom)
//        btn.adjustsImageWhenHighlighted = false;
//        btn.frame = CGRectMake(0, 0, 30, 40)
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
//
//        btn.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.imageView?.tintColor = UINavigationBar.appearance().tintColor ?? .red
//
//        btn.addActionHandler({ (control) in
//            self.navigationController!.popViewController(animated: true);
//        }, for: .touchUpInside)
//        let backItem = UIBarButtonItem(customView: btn)
//          navigationItem.leftBarButtonItem = backItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.addAction({ (item) in
            self.navigationController!.popViewController(animated: true);
        });
    }
}


