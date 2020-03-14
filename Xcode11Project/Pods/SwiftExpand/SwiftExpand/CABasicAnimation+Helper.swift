//
//  CABasicAnimation+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/3/29.
//  Copyright © 2019 BN. All rights reserved.
//

import QuartzCore
/// x方向平移
public let kTransformMoveX           = "transform.translation.x";
/// y方向平移
public let kTransformMoveY           = "transform.translation.y";
/// 比例转化
public let kTransformScale           = "transform.scale";
/// 宽的比例
public let kTransformScaleX          = "transform.scale.x";
/// 高的比例
public let kTransformScaleY          = "transform.scale.y";

public let kTransformRotationZ       = "transform.rotation.z";
public let kTransformRotationX       = "transform.rotation.x";
public let kTransformRotationY       = "transform.rotation.y";
/// 横向拉伸缩放 (0.4)最好是0~1之间的
public let kTransformSizW            = "contentsRect.size.width";
/// 位置(中心点的改变) [NSValue valueWithCGPoint:CGPointMake(300, 300)];
public let kTransformPosition        = "position";
/// 大小，中心不变  [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
public let kTransformBounds          = "bounds";
/// 内容,imageAnima.toValue = (id)[UIImage imageNamed:"to"].CGImage;
public let kTransformContents        = "contents";
/// 透明度
public let kTransformOpacity         = "opacity";
/// 圆角
public let kTransformCornerRadius    = "cornerRadius";
/// 背景
public let kTransformBackgroundColor = "backgroundColor";
/// path
public let kTransformPath            = "path";
///背景
public let kTransformStrokeEnd       = "strokeEnd";
/// kCAMediaTimingFunction集合
public let kFunctionNames = [
                            CAMediaTimingFunctionName.linear,//匀速
                            CAMediaTimingFunctionName.easeIn,//先慢
                            CAMediaTimingFunctionName.easeOut,//后慢
                            CAMediaTimingFunctionName.easeInEaseOut,//先慢 后慢 中间快
                            CAMediaTimingFunctionName.default//默认
                            ];

@objc public extension CABasicAnimation{
    
    /// [源]CABasicAnimation
    static func animKeyPath(_ keyPath: String,
                                  duration: CFTimeInterval,
                                  autoreverses: Bool = false,
                                  repeatCount: Float,
                                  fillMode: CAMediaTimingFillMode = .forwards,
                                  removedOnCompletion: Bool = false,
                                  functionName: CAMediaTimingFunctionName = .linear) -> CABasicAnimation {
        
        let anim = CABasicAnimation(keyPath: keyPath)
        anim.duration = duration;
        anim.repeatCount = repeatCount;
        anim.fillMode = fillMode;
        anim.isRemovedOnCompletion = removedOnCompletion;
        
        let name = kFunctionNames.contains(functionName) ? functionName : kFunctionNames.first;
        anim.timingFunction = CAMediaTimingFunction(name: name!);
        anim.isCumulative = keyPath == kTransformRotationZ;
        return anim;
    }
    
    /// [便捷]CABasicAnimation
    static func animKeyPath(_ keyPath: String,
                                  duration: CFTimeInterval,
                                  autoreverses: Bool = false,
                                  repeatCount: Float,
                                  fromValue: Any,
                                  toValue: Any) -> CABasicAnimation {
        let anim = animKeyPath(keyPath, duration: duration, repeatCount: repeatCount, functionName: kFunctionNames.first!);
        anim.fromValue = fromValue;
        anim.toValue = toValue;
        return anim;
    }
    
}
