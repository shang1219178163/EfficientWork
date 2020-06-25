//
//  UICollectionReusableView+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2018/12/22.
//


/*
 UICollectionViewCell继承于UICollectionReusableView,所以两者属性,方法不能同名
 */

import UIKit

@objc public extension UICollectionReusableView{
    /// [源]自定义 UICollectionReusableView 获取方法(兼容OC)
    static func dequeueSupplementaryView(_ collectionView: UICollectionView, kind: String = UICollectionView.elementKindSectionHeader, indexPath: IndexPath) -> Self{

//        let kindSuf = kind.components(separatedBy: "KindSection").last;
//        let identifier = self.identifier + kindSuf!;
        let identifier = kind == UICollectionView.elementKindSectionHeader ? identifyHeader : identifyFooter;
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        view.label.text = identifier + "\(indexPath.section)";

        view.backgroundColor = kind == UICollectionView.elementKindSectionHeader ? UIColor.green : UIColor.yellow;
        return view as! Self;
    }
    
    /// 表头值
    static var identifyHeader: String {
        return String(describing: self) + "Header";
     }
    /// 表尾值
    static var identifyFooter: String {
        return String(describing: self) + "Footer";
     }
 
    var imgView: UIImageView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UIImageView;
            if obj == nil {
                obj = UIImageView(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                obj!.isUserInteractionEnabled = true;
                obj!.contentMode = .scaleAspectFit;
//                obj!.backgroundColor = UIColor.random

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var imgViewRight: UIImageView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UIImageView;
            if obj == nil {
                obj = UIImageView(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                obj!.isUserInteractionEnabled = true;
                obj!.contentMode = .scaleAspectFit;
                obj!.image = UIImage(named: kIMG_arrowRight);
//                obj!.backgroundColor = UIColor.random
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
            
    var labelRight: UILabel {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UILabel;
            if obj == nil {
                obj = UILabel(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                obj!.numberOfLines = 1;
                obj!.adjustsFontSizeToFitWidth = true
                obj!.textAlignment = .center;
//                obj!.backgroundColor = UIColor.random
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var label: UILabel {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UILabel;
            if obj == nil {
                obj = UILabel(frame: .zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                obj!.font = UIFont.systemFont(ofSize: 15)
                obj!.numberOfLines = 0;
                obj!.lineBreakMode = .byCharWrapping;
                obj!.textAlignment = .center;
//                obj!.backgroundColor = UIColor.random

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var labelSub: UILabel {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UILabel;
            if obj == nil {
                obj = UILabel(frame: CGRect.zero);
                obj!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                obj!.font = UIFont.systemFont(ofSize: 13)
                obj!.numberOfLines = 0;
                obj!.lineBreakMode = .byCharWrapping;
                obj!.textAlignment = .center;
//                obj!.backgroundColor = UIColor.random
                
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var btn: UIButton {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UIButton;
            if obj == nil {
                obj = {
                    let btn = UIButton(type: .custom);
                    btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 15);
                    btn.titleLabel?.adjustsFontSizeToFitWidth = true;
                    btn.titleLabel?.minimumScaleFactor = 1.0;
                    btn.isExclusiveTouch = true;
                    btn.setTitleColor(.textColor3, for: .normal)
                    btn.setTitleColor(.theme, for: .selected)
                    return btn
                }()
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}
