
//
//  UIViewController+Add.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/29.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension UIViewController{
    /// 关联obj任意对象
    var obj: AnyObject? {
        get {
            return objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as AnyObject;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 关联obj任意对象
    var objOne: AnyObject? {
        get {
            return objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as AnyObject;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 关联NSMutableArray 数据容器
    var dataList: NSMutableArray {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? NSMutableArray;
            if obj == nil {
                obj = [];
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 关联UITableView视图对象
    var tbView: UITableView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UITableView;
            if obj == nil {
                obj = UITableView.create(view.bounds, style: .plain, rowHeight: 70);
                if self.conforms(to: UITableViewDataSource.self) {
                    obj!.dataSource = self as? UITableViewDataSource;
                }
                if self.conforms(to: UITableViewDelegate.self) {
                    obj!.delegate = self as? UITableViewDelegate;
                }

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 关联UITableView视图对象
    var tbViewGrouped: UITableView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UITableView;
            if obj == nil {
                obj = UITableView.create(view.bounds, style: .grouped, rowHeight: 70);
                if self.conforms(to: UITableViewDataSource.self) {
                    obj!.dataSource = self as? UITableViewDataSource;
                }
                if self.conforms(to: UITableViewDelegate.self) {
                    obj!.delegate = self as? UITableViewDelegate;
                }

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 关联UICollectionView视图对象
    var ctView : UICollectionView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UICollectionView;
            if obj == nil {
                // 初始化
                obj = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.layoutDefault)
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                obj!.isPagingEnabled = true;
                obj!.backgroundColor = UIColor.background

                obj!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
                if self.conforms(to: UICollectionViewDelegate.self) {
                    obj!.delegate = (self as! UICollectionViewDelegate)
                }
                if self.conforms(to: UICollectionViewDataSource.self) {
                    obj!.dataSource = (self as! UICollectionViewDataSource)
                }
 
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 关联tipLab
    var tipLab : UILabel {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UILabel;
            if obj == nil {
                // 初始化
                obj = UILabel()
                obj!.text = "暂无数据"
                obj!.textColor = UIColor.gray;
                obj!.sizeToFit();
                obj!.center = self.view.center;
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}
