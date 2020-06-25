//
//  UIView+Animation.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/9/6.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension UIView{
    
    func animRotation(fromValue: Double = 0,
                            toValue: Double = Double.pi * 2,
                            duration: Double = Double(kDurationRotation),
                            repeatCount: Float = MAXFLOAT,
                            key: String?) {
        // 1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        anim.fromValue = fromValue;
        anim.toValue = toValue;
        anim.duration = duration;
        anim.repeatCount = repeatCount;
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        anim.isRemovedOnCompletion = false
        // 3.将动画添加到layer中
        layer.add(anim, forKey: key);
    }
    
    func animRotation(isClockwise: Bool = true,
                            duration: Double = Double(kDurationRotation),
                            repeatCount: Float = MAXFLOAT,
                            key: String? = nil) {
        let fromValue = isClockwise == true ? 0 : Double.pi * 2;
        let toValue = isClockwise == true ? Double.pi * 2 : 0;
        animRotation(fromValue: fromValue, toValue: toValue, duration: duration, repeatCount: repeatCount, key: key);
    }
    
    ///MARK:循环旋转图像(默认180°)
    func transformRotationCycle(_ duration: TimeInterval = 0.35, angle: CGFloat = CGFloat(Double.pi)) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = self.transform.isIdentity == true ? self.transform.rotated(by: angle) : CGAffineTransform.identity;
        })
    }
}
