//
//  CATransition+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/3/29.
//  Copyright © 2019 BN. All rights reserved.
//
import QuartzCore
/// 立方体效果
public let kCATransitionCube                  = "cube";
/// 阿拉神灯效果
public let kCATransitionSuckEffect            = "suckEffect";
/// 上下左右翻转效果
public let kCATransitionOglFlip               = "oglFlip";
/// 水滴效果
public let kCATransitionRippleEffect          = "rippleEffect";
/// 向上翻页效果
public let kCATransitionPageCurl              = "pageCurl";
/// 向下翻页效果
public let kCATransitionPageUnCurl            = "pageUnCurl";
/// 相机镜头打开效果
public let kCATransitionCameraIrisHollowOpen  = "cameraIrisHollowOpen";
/// 相机镜头关闭效果
public let kCATransitionCameraIrisHollowClose = "cameraIrisHollowClose";
/// 动画方向
public let kSubTypeFuntionNames = [CATransitionSubtype.fromTop,
                                   CATransitionSubtype.fromLeft,
                                   CATransitionSubtype.fromBottom,
                                   CATransitionSubtype.fromRight];

@objc public extension CATransition{
   
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
