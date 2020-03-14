//
//  CATransaction+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/3/29.
//  Copyright © 2019 BN. All rights reserved.
//
import QuartzCore

@objc public extension CATransaction{
    
    /// [源]CATransaction动画
    static func animDuration(_ duration: CFTimeInterval, animations: (() -> Void)?, completionBlock: (() -> Void)?) {

        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        if animations != nil {
            animations!()
        }
        CATransaction.setCompletionBlock(completionBlock)
        CATransaction.commit()
    }
    
  
    
}
