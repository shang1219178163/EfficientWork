
//
//  UIViewController+Add.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/29.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension UIViewController{

    /// 关联NSMutableArray 数据容器
    var dataList: NSMutableArray {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? NSMutableArray {
                return obj
            }

            let obj = NSMutableArray()
            
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return obj;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 关联UITableView视图对象
    var tbView: UITableView {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UITableView {
                return obj
            }
            
            let obj = UITableView.create(view.bounds, style: .grouped, rowHeight: 50);
            if self.conforms(to: UITableViewDataSource.self) {
                obj.dataSource = self as? UITableViewDataSource;
            }
            if self.conforms(to: UITableViewDelegate.self) {
                obj.delegate = self as? UITableViewDelegate;
            }
            
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return obj;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 关联UITableView视图对象
    var tbViewGrouped: UITableView {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UITableView {
                return obj
            }

            let obj = UITableView.create(view.bounds, style: .grouped, rowHeight: 50);
            if self.conforms(to: UITableViewDataSource.self) {
                obj.dataSource = self as? UITableViewDataSource;
            }
            if self.conforms(to: UITableViewDelegate.self) {
                obj.delegate = self as? UITableViewDelegate;
            }
            
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return obj;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 关联UICollectionView视图对象
    var ctView: UICollectionView {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UICollectionView {
                return obj
            }
            // 初始化
            let obj = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.layoutDefault)
            obj.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            obj.isPagingEnabled = true;
            obj.backgroundColor = UIColor.background

            obj.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
            if self.conforms(to: UICollectionViewDataSource.self) {
                obj.dataSource = (self as! UICollectionViewDataSource)
            }
             
            if self.conforms(to: UICollectionViewDelegate.self) {
                obj.delegate = (self as! UICollectionViewDelegate)
            }
            
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return obj;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 关联tipLab
    var tipLab: UILabel {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UILabel {
                return obj
            }
                // 初始化
            let obj = UILabel()
            obj.text = "暂无数据"
            obj.textColor = .gray;
            obj.sizeToFit();
            obj.center = self.view.center;
                
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return obj;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
//    /// 关联UITableView视图对象(必须先添加到父视图再设置其他)
//    var tbView: UITableView {
//        guard let tableView = self.view.subView(UITableView.self) as? UITableView else {
//            let obj = UITableView.create(self.view.bounds, style: .plain, rowHeight: 50)
//            if self.conforms(to: UITableViewDataSource.self) {
//                obj.dataSource = self as? UITableViewDataSource;
//            }
//            if self.conforms(to: UITableViewDelegate.self) {
//                obj.delegate = self as? UITableViewDelegate;
//            }
//            return obj
//        }
//        return tableView
//    }
//    /// 关联UITableView视图对象(必须先添加到父视图再设置其他)
//    var tbViewGrouped: UITableView {
//        guard let tableView = self.view.subView(UITableView.self) as? UITableView else {
//            let obj = UITableView.create(self.view.bounds, style: .grouped, rowHeight: 50)
//            if self.conforms(to: UITableViewDataSource.self) {
//                obj.dataSource = self as? UITableViewDataSource;
//            }
//            if self.conforms(to: UITableViewDelegate.self) {
//                obj.delegate = self as? UITableViewDelegate;
//            }
//            return obj
//        }
//        return tableView
//    }
//    /// 关联UICollectionView视图对象(必须先添加到父视图再注册Cell)
//    var ctView: UICollectionView {
//        guard let collectionView = self.view.subView(UICollectionView.self) as? UICollectionView else {
//            // 初始化
//            let obj = UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionView.layoutDefault)
//            obj.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            obj.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
//            obj.backgroundColor = UIColor.background
//
//            if self.conforms(to: UICollectionViewDelegate.self) {
//                obj.delegate = (self as! UICollectionViewDelegate)
//            }
//            if self.conforms(to: UICollectionViewDataSource.self) {
//                obj.dataSource = (self as! UICollectionViewDataSource)
//            }
//            return view
//        }
//        return collectionView
//    }

}
