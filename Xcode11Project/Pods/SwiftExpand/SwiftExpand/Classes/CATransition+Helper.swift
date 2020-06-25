//
//  CATransition+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/3/29.
//  Copyright © 2019 BN. All rights reserved.
//
import QuartzCore


@objc public extension CATransition{
    // MARK: - kCATransition
    /// 立方体效果
    static let kCATransitionCube                  = "cube";
    /// 阿拉神灯效果
    static let kCATransitionSuckEffect            = "suckEffect";
    /// 上下左右翻转效果
    static let kCATransitionOglFlip               = "oglFlip";
    /// 水滴效果
    static let kCATransitionRippleEffect          = "rippleEffect";
    /// 向上翻页效果
    static let kCATransitionPageCurl              = "pageCurl";
    /// 向下翻页效果
    static let kCATransitionPageUnCurl            = "pageUnCurl";
    /// 相机镜头打开效果
    static let kCATransitionCameraIrisHollowOpen  = "cameraIrisHollowOpen";
    /// 相机镜头关闭效果
    static let kCATransitionCameraIrisHollowClose = "cameraIrisHollowClose";
    /// 动画方向
    static let kSubTypeFuntionNames = [CATransitionSubtype.fromTop,
                                      CATransitionSubtype.fromLeft,
                                      CATransitionSubtype.fromBottom,
                                      CATransitionSubtype.fromRight];
    /// [源]CATransition
    static func animDuration(_ duration: CFTimeInterval,
                                   functionName: CAMediaTimingFunctionName = .linear,
                                   type: CATransitionType = .fade,
                                   subType: CATransitionSubtype? = nil) -> CATransition {

        let anim = CATransition()
        anim.duration = duration;
       
        let name = kFunctionNames.contains(functionName) ? functionName : kFunctionNames.first;
        anim.timingFunction = CAMediaTimingFunction(name: name!);
        anim.type = type
        anim.subtype = subType
        return anim;
    }
    
}
