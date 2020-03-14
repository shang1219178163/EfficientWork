//
//  NSMutableParagraphStyle+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/4/25.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit

@objc public extension NSMutableParagraphStyle{
     /// 创建NSMutableParagraphStyle
     static func create(_ lineBreakMode: NSLineBreakMode = .byCharWrapping,
                                    alignment: NSTextAlignment = .left,
                                  lineSpacing: CGFloat = 5.0) -> NSMutableParagraphStyle {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = lineBreakMode;
        paraStyle.alignment = alignment;
        paraStyle.lineSpacing = lineSpacing;
        return paraStyle
    }
}
