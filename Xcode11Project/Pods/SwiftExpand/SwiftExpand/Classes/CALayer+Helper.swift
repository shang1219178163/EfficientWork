//
//  CALayer+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/1/15.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

@objc public extension CALayer{
    /// [源]创建 CALayer
    static func create(_ rect: CGRect = .zero, contents: Any?) -> Self {
        let layer = self.init()
        layer.frame = rect
        layer.contents = contents
        layer.contentsScale = UIScreen.main.scale
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        return layer
    }
    /// 线条位置
    func rectWithLine(type: Int = 0, width: CGFloat = 0.8, paddingScale: CGFloat = 0) -> CGRect {
        var rect = CGRect.zero;
        switch type {
        case 1://左边框
            let paddingY = bounds.height*paddingScale;
            rect = CGRectMake(0, paddingY, bounds.width, bounds.height - paddingY*2)
            
        case 2://下边框
            let paddingX = bounds.width*paddingScale;
            rect = CGRectMake(paddingX, bounds.height - width, bounds.width - paddingX*2, width)
            
        case 3://右边框
            let paddingY = bounds.height*paddingScale;
            rect = CGRectMake(bounds.width - width, paddingY, bounds.width, bounds.height - paddingY*2)
            
        default: //上边框
            let paddingX = bounds.width*paddingScale;
            rect = CGRectMake(paddingX, 0, bounds.width - paddingX*2, width)
        }
        return rect;
    }
    /// 创建CALayer 线条
    func createLayer(type: Int = 0, color: UIColor = UIColor.line, width: CGFloat = 0.8, paddingScale: CGFloat = 0) -> CALayer {
        let linView = CALayer()
        linView.backgroundColor = color.cgColor;
        linView.frame = self.rectWithLine(type: type, width: width, paddingScale: paddingScale);
        return linView;
    }
    /// 控制器切换渐变动画
    func addAnimationFade(_ duration: CFTimeInterval = 0.15, functionName: CAMediaTimingFunctionName = .easeIn) {
        let anim = CATransition()
        anim.duration = duration;
        anim.timingFunction = CAMediaTimingFunction(name: functionName);
        anim.type = .fade
        anim.isRemovedOnCompletion = true;
        self.add(anim, forKey: "transitionView")
    }
    
    /// 来回移动动画
    func shakeAnimation() {
        let anim = CAKeyframeAnimation(keyPath: "position.x")
        //获取当前View的position坐标
        let positionX = self.position.x
        //设置抖动的范围
        anim.values = [(positionX-10),(positionX),(positionX+10)]
        //动画重复的次数
        anim.repeatCount = 3
        //动画时间
        anim.duration = 0.07
        //设置自动反转
        anim.autoreverses = true
        //将动画添加到layer
        self.add(anim, forKey: nil)
    }
}
