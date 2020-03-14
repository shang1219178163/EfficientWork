//
//  CAKeyframeAnimation+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/3/29.
//  Copyright © 2019 BN. All rights reserved.
//
import QuartzCore

@objc public extension CAKeyframeAnimation{
    
    /// [源]CAKeyframeAnimation
    static func animDuration(_ duration: CFTimeInterval,
                                   autoreverses: Bool = false,
                                   repeatCount: Float,
                                   fillMode: CAMediaTimingFillMode = .forwards,
                                   removedOnCompletion:Bool = false,
                                   functionName: CAMediaTimingFunctionName) -> CAKeyframeAnimation {
        let anim: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: kTransformPosition);
        anim.duration = duration;
        anim.repeatCount = repeatCount;
        anim.fillMode = fillMode;
        anim.isRemovedOnCompletion = removedOnCompletion;
        
        let name = kFunctionNames.contains(functionName) ? functionName : kFunctionNames.first;
        anim.timingFunction = CAMediaTimingFunction(name: name!);
        return anim;
    }
    
    /// CAKeyframeAnimation
    static func animPath(_ pathRef:CGPath, duration: CFTimeInterval, autoreverses: Bool = false, repeatCount: Float) -> CAKeyframeAnimation {
        let anim: CAKeyframeAnimation = CAKeyframeAnimation.animDuration(duration, repeatCount: repeatCount, functionName: .default)
        anim.path = pathRef;
        return anim;
    }
    
    /// CAKeyframeAnimation
    static func animValues(_ values: [Any], duration: CFTimeInterval, autoreverses: Bool = false, repeatCount: Float) -> CAKeyframeAnimation {
        let anim: CAKeyframeAnimation = CAKeyframeAnimation.animDuration(duration, repeatCount: repeatCount, functionName: .default)
        anim.values = values;
        return anim;
    }
    
   
}
