//
//  UISlider+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/11/9.
//

import UIKit

@objc public extension UISlider{

    /// [源]UISlider创建
    static func create(_ rect: CGRect = .zero, value: Float, minValue: Float = 0, maxValue: Float = 100) -> Self {
        let view = self.init(frame: rect)
        view.autoresizingMask = .flexibleWidth
        view.minimumValue = minValue
        view.maximumValue = maxValue
        view.value = value;
        
        view.minimumTrackTintColor = UIColor.theme
        return view;
    }
}
