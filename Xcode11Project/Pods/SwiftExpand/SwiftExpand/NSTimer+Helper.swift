//
//  NSTimer+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/2/15.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

@objc extension Timer{
    
    /// 分类方法
    public static func scheduled(_ Interval: TimeInterval = 60, repeats: Bool = true, action: @escaping((Timer) -> Void)) -> Timer {
        return scheduledTimer(timeInterval: Interval, target: self, selector: #selector(handleInvoke(_:)), userInfo: action, repeats: repeats)
    }
    
    private static func handleInvoke(_ timer: Timer) {
        if let action = timer.userInfo as? ((Timer) -> Void) {
            action(timer)
        }
    }
    
    public static func stopTimer(_ timer: Timer) {
        timer.invalidate()
    }
    
    public static func pause(_ timer: Timer, isPause: Bool) {
        //    暂停：触发时间设置在未来，既很久之后，这样定时器自动进入等待触发的状态.
        //    继续：触发时间设置在现在/获取，这样定时器自动进入马上进入工作状态.
        timer.fireDate = isPause == true ? NSDate.distantFuture : Date();
    }
    
    public func pause(_ isPause: Bool) {
        Timer.pause(self, isPause: isPause)
    }
    
    public static func createGCDTimer(_ interval: TimeInterval = 60, repeats: Bool = true, action: @escaping(() -> Void)) -> DispatchSourceTimer {
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
        codeTimer.setEventHandler {
            if repeats == false {
                codeTimer.cancel()
            }
            DispatchQueue.main.async(execute: action)
        }
        
        codeTimer.resume()
        return codeTimer;
    }
}
