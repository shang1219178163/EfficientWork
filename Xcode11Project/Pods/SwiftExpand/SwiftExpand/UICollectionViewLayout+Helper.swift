//
//  UICollectionViewLayout+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/1/16.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

@objc public extension UICollectionViewLayout{
    
    /// 仿 flowLayout
    var minimumLineSpacing: CGFloat {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? CGFloat {
                return obj
            }
            return 5.0
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 仿 flowLayout
    var minimumInteritemSpacing: CGFloat {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? CGFloat {
                return obj
            }
            return 5.0
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 仿 flowLayout
    var itemSize: CGSize {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? CGSize {
                return obj
            }
            return CGSize.zero
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 仿 flowLayout
    var headerReferenceSize: CGSize {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? CGSize {
                return obj
            }
            return CGSize.zero
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 仿 flowLayout
    var footerReferenceSize: CGSize {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? CGSize {
                return obj
            }
            return CGSize.zero
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 仿 flowLayout
    var sectionInset: UIEdgeInsets {
        get {
            if let obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UIEdgeInsets {
                return obj
            }
            return UIEdgeInsets.zero
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
   
    /// 默认布局配置(自上而下,自左而右)
    static func createLayout(_ itemSize: CGSize,
                                   spacing: CGFloat = kPadding,
                                   headerSize: CGSize,
                                   footerSize: CGSize,
                                   sectionInset: UIEdgeInsets = .zero) -> UICollectionViewLayout {
        let layout = UICollectionViewLayout();
        //item水平间距
        layout.minimumLineSpacing = spacing;
        //item垂直间距
        layout.minimumInteritemSpacing = spacing;
        //item的UIEdgeInsets
        layout.sectionInset = sectionInset;
        //item的尺寸
        layout.itemSize = itemSize;
        //滑动方向,默认垂直
        //sectionView 尺寸
        layout.headerReferenceSize = headerSize;
        layout.footerReferenceSize = footerSize;
        return layout;
    }
    ///  默认布局配置(自上而下,自左而右)
    static func createFlowLayout(_ rowNum: Int = 4,
                                       width: CGFloat = UIScreen.main.bounds.width,
                                       spacing: CGFloat = 10,
                                       headerHeight: CGFloat = 30,
                                       footerHeight: CGFloat = 30,
                                       sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) -> UICollectionViewFlowLayout {
        //
        let layout = UICollectionViewFlowLayout();
        layout.sectionInset = sectionInset;
        
        let itemWidth = (width - (rowNum.toCGFloat + 1)*spacing - sectionInset.left - sectionInset.right)/rowNum.toCGFloat;
        let itemHeight = itemWidth/0.75;
        layout.itemSize = CGSize(width: round(itemWidth), height: itemHeight);
        layout.headerReferenceSize = CGSize(width: width, height: headerHeight);
        layout.footerReferenceSize = CGSize(width: width, height: footerHeight);
        return layout;
    }
}
