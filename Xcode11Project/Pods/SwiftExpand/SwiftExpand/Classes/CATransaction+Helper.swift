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
    static func animDuration(_ duration: CFTimeInterval, functionName: CAMediaTimingFunctionName = .linear, animations: (() -> Void), completionBlock: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: functionName));
        animations()
        CATransaction.setCompletionBlock(completionBlock)
        CATransaction.commit()
    }
    
  
    
}
