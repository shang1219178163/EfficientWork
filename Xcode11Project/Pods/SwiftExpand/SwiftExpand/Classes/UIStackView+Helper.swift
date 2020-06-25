
//
//  UIStackView+Helper.swift
//  Alamofire
//
//  Created by Bin Shang on 2019/11/26.
//

import UIKit

@available(iOS 9.0, *)
@objc public extension UIStackView {
    
    static func create(_ rect: CGRect, spacing: CGFloat = 10.0) -> Self {
        let view: UIStackView = self.init(frame: rect);
//        view.autoresizingMask = [.width, .height];
        //设置子视图间隔
        view.spacing = spacing
        //子视图的高度或宽度保持一致
//        view.distribution = .fillEqually
        view.distribution = .fillProportionally

        return view as! Self;
    }

    /// 设置子视图显示比例(此方法前请设置 .axis/.orientation)
    func setSubViewMultiplier(_ multiplier: CGFloat, at index: Int) {
        if index < subviews.count {
            let element = subviews[index];
            if self.axis == .horizontal {
                element.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier).isActive = true

            } else {
                element.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: multiplier).isActive = true
            }
        }
    }

}
