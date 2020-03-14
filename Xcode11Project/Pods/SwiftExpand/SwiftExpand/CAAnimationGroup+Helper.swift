//
//  CAAnimationGroup+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/3/29.
//  Copyright © 2019 BN. All rights reserved.
//

import QuartzCore

@objc public extension CAAnimationGroup{
    
    /// [源]CAAnimationGroup
    static func animDuration(_ duration: CFTimeInterval,
                                   autoreverses: Bool = false,
                                   repeatCount: Float,
                                   fillMode: CAMediaTimingFillMode = .forwards,
                                   removedOnCompletion: Bool = false) -> CAAnimationGroup {
        
        let anim: CAAnimationGroup = CAAnimationGroup();
        anim.duration = duration;
        anim.repeatCount = repeatCount;
        anim.autoreverses = autoreverses;
        anim.fillMode = fillMode;
        anim.isRemovedOnCompletion = removedOnCompletion;
        return anim;
    }
    
    /// [简]CAAnimationGroup
    static func animDuration(_ animList: [CAAnimation],
                                   duration: CFTimeInterval,
                                   repeatCount: Float) -> CAAnimationGroup {
        let anim = CAAnimationGroup.animDuration(duration, repeatCount: repeatCount)
        anim.animations = animList;
        return anim;
    }
    
}
