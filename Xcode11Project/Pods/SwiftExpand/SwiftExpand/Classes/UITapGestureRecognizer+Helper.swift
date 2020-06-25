//
//  UITapGestureRecognizer+Helper.swift
//  IntelligentOfParking
//
//  Created by Bin Shang on 2020/4/17.
//  Copyright © 2020 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

@objc public extension UITapGestureRecognizer {
    /// UILabel 富文本点击
    func didTapAttributedTextIn(label: UILabel, tapTexts: [String], action: @escaping (String, Int) -> Void) {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines

        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width)*0.5 - textBoundingBox.origin.x,
                                        y:(labelSize.height - textBoundingBox.size.height)*0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                   y: locationOfTouchInLabel.y - textContainerOffset.y);

        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                          in: textContainer,
                                                          fractionOfDistanceBetweenInsertionPoints: nil)

        if label.text == nil {
            return;
        }
        
        for e in tapTexts.enumerated() {
            let targetRange: NSRange = (label.text! as NSString).range(of: e.element)
            let isContain = NSLocationInRange(indexOfCharacter, targetRange)
            if isContain {
                action(e.element, e.offset)
            }
        }
    }
}
