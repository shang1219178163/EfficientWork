
//
//  UIView+Add.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/27.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit


@objc public extension UIView {
    
    ///视图方向(上左下右)
    @objc enum Direction: Int {
        case top
        case left
        case bottom
        case right
        case center
    }

    ///视图角落(左上,左下,右上,右下)
    @objc enum Location: Int {
        case none
        case leftTop
        case leftBottom
        case rightTop
        case rightBottom
    }

    @objc enum HolderViewState: Int {
        case nomrol, loading, empty, fail
    }
    
    var lineTop: UIView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UIView;
            if obj == nil {
                obj = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: kH_LINE_VIEW));
                obj!.backgroundColor = .line

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var lineBottom: UIView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UIView;
            if obj == nil {
                obj = UIView(frame: CGRect(x: 0, y: frame.maxY - kH_LINE_VIEW, width: frame.width, height: kH_LINE_VIEW));
                obj!.backgroundColor = .line
//                addSubview(obj!)

                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    var lineRight: UIView {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UIView;
            if obj == nil {
                obj = UIView(frame: CGRect(x: frame.maxX - kH_LINE_VIEW, y: 0, width: kH_LINE_VIEW, height: frame.height));
                obj!.backgroundColor = .line
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    /// 渐变色层
    var gradientLayer: CAGradientLayer {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? CAGradientLayer;
            if obj == nil {
                let colors = [UIColor.theme.withAlphaComponent(0.5).cgColor, UIColor.theme.withAlphaComponent(0.9).cgColor]
                obj = CAGradientLayer.layerRect(CGRect.zero, colors: colors, start: CGPointMake(0, 0), end: CGPointMake(1.0, 0))
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj!;
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
        
    /// (与holderView配置方法)配套使用
    var holderView: UIView {
        var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as? UIView;
        if obj == nil {
            obj = UIView(frame: bounds);
            obj!.backgroundColor = UIColor.white

            obj!.isHidden = true;

            let height = bounds.height - 25*2
            let YGap = height*0.2
            let imgView = UIImageView(frame: CGRectMake(0, YGap, bounds.width, height*0.3))
            imgView.contentMode = .scaleAspectFit
            imgView.contentMode = .center

            imgView.tag = kTAG_IMGVIEW
            obj!.addSubview(imgView)

            let label = UILabel(frame: CGRectMake(0, imgView.frame.maxY + 25, bounds.width, 25))
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .center
//            label.text = "暂无数据"
            label.textColor = .gray
            label.tag = kTAG_LABEL
            obj!.addSubview(label)
            
            addSubview(obj!)
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return obj!;
    }
    
    /// 配置HolderView
    func setHolderView(for state: HolderViewState = .nomrol) {
        guard let imgView = holderView.subView(UIImageView.self) as? UIImageView,
            let label = holderView.subView(UILabel.self) as? UILabel
            else { return }
        
        label.isHidden = (state == .nomrol)
        imgView.isHidden = (state == .nomrol)

        switch state {
        case .empty:
            label.text = "暂无数据"
            imgView.image = UIImage.image(named: "img_data_empty", podClassName: "SwiftExpand")
            
        case .loading:
            label.text = "加载中..."
            imgView.image = UIImage.image(named: "img_network_loading", podClassName: "SwiftExpand")
            
        case .fail:
            label.text = "请求失败"
            imgView.image = UIImage.image(named: "img_network_error", podClassName: "SwiftExpand")
            
        default:
            break
        }
    }
    
    func setHolderViewTitle(_ title: String, for state: HolderViewState = .nomrol) {
        guard let label = holderView.subView(UILabel.self) as? UILabel
            else { return }
        
        label.isHidden = (state == .nomrol)
        label.text = title
    }
    
    func setHolderViewImage(_ image: UIImage, for state: HolderViewState = .nomrol) {
        guard let imgView = holderView.subView(UIImageView.self) as? UIImageView
            else { return }
        
        imgView.isHidden = (state == .nomrol)
        imgView.image = image
    }
    
    /// 增加虚线边框
    func addLineDashLayer(color: UIColor = UIColor.red,
                                    width: CGFloat = 1,
                                    dashPattern: [NSNumber] = [NSNumber(floatLiteral: 4), NSNumber(floatLiteral: 5)],
                                    cornerRadius: CGFloat = 0,
                                    size: CGSize = CGSize.zero) {
        let view: UIView = self;
        assert(CGRect.zero.equalTo(view.bounds) == true && CGSize.zero.equalTo(size));

        view.layer.borderColor = UIColor.clear.cgColor;
        view.layer.borderWidth = 0;
        
        let shapeLayer = CAShapeLayer();
        shapeLayer.strokeColor = color.cgColor;
        shapeLayer.fillColor = UIColor.clear.cgColor;
        
        shapeLayer.frame = CGSize.zero.equalTo(size) ? view.bounds : CGRect(x: 0, y: 0, width: size.width, height: size.height);
        shapeLayer.path = UIBezierPath(roundedRect: shapeLayer.frame, cornerRadius: cornerRadius).cgPath;
        
        shapeLayer.lineWidth = width;
        shapeLayer.lineDashPattern = dashPattern;
        shapeLayer.lineCap = .square;
        if cornerRadius > 0 {
            view.layer.cornerRadius = cornerRadius;
            view.layer.masksToBounds = true;
        }
        view.layer.addSublayer(shapeLayer);
    }
    
     /// 获取密集子视图的总高度
    static func groupViewHeight(_ count: Int = 9, numberOfRow: Int = 4, padding: CGFloat = 12, itemHeight: CGFloat = 40) -> CGFloat {
        let rowCount = count % numberOfRow == 0 ? count/numberOfRow : count/numberOfRow + 1;
        return rowCount.toCGFloat * itemHeight + (rowCount - 1).toCGFloat * padding;
    }
    
    
}


public extension UIView{
    
    ///更新各种子视图
    final func updateItems<T: UIView>(_ count: Int, type: T.Type, hanler: ((T) -> Void)? = nil) -> [T] {
        if let list = self.subviews.filter({ $0.isKind(of: type) }) as? [T] {
            if list.count == count {
                return list
            }
        }
        
        self.subviews.forEach { $0.removeFromSuperview() }
        
        var arr: [T] = [];
        for i in 0..<count {
            let subview = type.init()
            subview.tag = i
            self.addSubview(subview)
            arr.append(subview)
            
            hanler?(subview)
        }
        return arr;
    }
    
    ///更新各种子类按钮
    final func updateButtonItems<T: UIButton>(_ count: Int, type: T.Type, hanler: ((T) -> Void)? = nil) -> [T] {
        return updateItems(count, type: type) {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.setTitle("\(type)\($0.tag)", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setBackgroundColor(.gray, for: .disabled)
        }
    }
    
    ///更新各种子类UILabel
    final func updateLabelItems<T: UILabel>(_ count: Int, type: T.Type, hanler: ((T) -> Void)? = nil) -> [T] {
        return updateItems(count, type: type) {
            $0.text = "\(type)\($0.tag)"
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 15)
        }
    }
}
